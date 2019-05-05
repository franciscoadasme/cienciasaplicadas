class Admin::UsersController < AdminController
  before_action :authorize_user!
  before_action :set_user, except: [ :index ]
  before_action :ensure_admin!, only: [ :promote, :demote ]
  before_action :validate_accepted_user, only: [ :promote, :demote ]

  def index
    @users_count = (current_user.super_user? ? User.count : User.invitation_accepted.count) - 1
    @users_accepted = User.invitation_accepted.where.not(id: current_user.id).sorted
    @users_not_accepted = User.invitation_not_accepted if current_user.super_user?
    @positions = Position.sorted
  end

  def destroy
    if @user.admin?
      redirect_to_index error: :cannot_delete_admin
    elsif @user == current_user
      redirect_to_index error: :cannot_delete_self
    else
      @user.destroy
      redirect_to_index success: true
    end
  end

  def demote
    change_user_role :demote
  end

  def edit
  end

  def promote
    change_user_role :promote
  end

  def change_position
    @user.position = Position.find params[:position_id]
    @user.member = Position::MEMBERSHIP.include? @user.position
    @user.save! validate: false
    redirect_to_index success: true
  end

  def update
    params = user_params
    unless @user.accepted?
      params[:nickname] = @user.email[/^(.*)(@)/, 1].delete! ".-_0123456789"
      params[:password] = params[:nickname]
      params[:invitation_accepted_at] = DateTime.current
      params[:invitation_token] = nil
    end

    if @user.update(params)
      redirect_to admin_users_path, success: {user: @user.display_name}
    else
      render action: 'edit'
    end
  end

  protected

  def authorize_user!
    return if current_user.super_user?
    alert_msg = t 'devise.failure.unauthorized'
    redirect_to profile_admin_account_path, alert: alert_msg
  end

    def change_user_role action
      @user.send "#{action}!"
      redirect_to_index success: { action: :change_user_role, role: @user.role_name }
    end

    def ensure_admin!
      redirect_to_index alert: :not_admin unless current_user.admin?
    end

    def set_user
      @user = User.find params[:id]
    end

    def validate_accepted_user
      redirect_to_index alert: t('devise.invitations.not_accepted') unless @user.accepted?
    end
  
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :headline,
      :image_url
    )
  end
end
