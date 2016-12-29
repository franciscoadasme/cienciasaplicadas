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

  def promote
    change_user_role :promote
  end

  def change_position
    @user.position = Position.find params[:position_id]
    @user.save! validate: false
    redirect_to_index success: true
  end

  protected
    def authorize_user!
      redirect_to_index alert: t('devise.failure.unauthorized') unless current_user.super_user?
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
end
