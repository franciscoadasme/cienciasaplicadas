class Admin::UsersController < AdminController
  before_action :authorize_user!, except: [ :index ]
  before_action :set_user, except: [ :index ]
  before_action :validate_accepted_user, only: [ :promote, :demote ]

  def index
    @users_count = (current_user.super_user? ? User.count : User.invitation_accepted.count) - 1
    @users_accepted = User.invitation_accepted.where.not(id: current_user.id)
    @users_not_accepted = User.invitation_not_accepted if current_user.super_user?
  end

  def destroy
    if @user.admin?
      redirect_to admin_users_path, error: t('actions.users.failure.cannot_delete_admin')
    elsif @user == current_user
      redirect_to admin_users_path, alert: t('actions.users.failure.cannot_delete_self')
    else
      @user.destroy
      redirect_to admin_users_path, success: t('actions.users.messages.destroy')
    end
  end

  def demote
    change_user_role :demote
  end

  def promote
    change_user_role :promote
  end

  protected
    def authorize_user!
      redirect_to admin_users_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def change_user_role action
      @user.send "#{action}!"
      respond_to do |format|
        format.html { redirect_to admin_users_path, success: t('actions.users.messages.change_user_role', role: @user.role_name) }
        format.json { head :no_content }
      end
    end

    def set_user
      @user = User.find params[:id]
    end

    def validate_accepted_user
      redirect_to admin_users_path, alert: t('devise.invitations.not_accepted') unless @user.accepted?
    end
end