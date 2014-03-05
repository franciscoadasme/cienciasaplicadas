class Admin::Users::InvitationsController < Devise::InvitationsController
  layout 'admin'
  before_action :authorize_user!, except: [ :edit, :update ]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    self.resource = resource_class.new invite_params
    if resource.valid_attributes?(:email, :position)
      super
    else
      render action: :new
    end
  end

  def edit
    resource.nickname = resource.suggested_nickname
    super
  end

  def resend_invitation
    @user = User.where(invitation_token: params[:invitation_token]).first
    if @user
      if @user.accepted?
        redirect_to admin_users_path, notice: t('devise.invitations.already_accepted', email: @user.email)
      else
        @user.deliver_invitation
        redirect_to admin_users_path, success: t('devise.invitations.send_instructions', email: @user.email)
      end
    else
      redirect_to admin_users_path, alert: t('devise.invitations.invitation_token_invalid')
    end
  end

  protected
    def after_invite_path_for resource
      admin_users_path
    end

    def authorize_user!
      redirect_to admin_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:invite).concat [ :position_id ]
      devise_parameter_sanitizer.for(:accept_invitation).concat [ :first_name, :last_name, :nickname, :image_url ]
    end
end