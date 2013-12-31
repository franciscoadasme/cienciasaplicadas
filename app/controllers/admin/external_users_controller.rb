class Admin::ExternalUsersController < AdminController
  before_action :authorize_user!
  before_action :find_external_user, only: [ :edit, :update, :destroy ]

  def index
    @external_users = ExternalUser.all
  end

  def new
    @external_user = ExternalUser.new
  end

  def edit
  end

  def create
    @external_user = ExternalUser.new(external_user_params)

    if @external_user.save
      redirect_to admin_external_users_path, success: 'External user created successfully.'
    else
      render action: 'new'
    end
  end

  def update
    if @external_user.update(external_user_params)
      redirect_to admin_external_users_path, success: 'External user updated successfully.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @external_user.destroy
    redirect_to admin_external_users_path, notice: 'External user was deleted permanently.'
  end

  private
    def authorize_user!
      redirect_to admin_projects_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def find_external_user
      @external_user = ExternalUser.find(params[:id]) if params[:id]
    end

    def external_user_params
      params.require(:external_user).permit(
        :first_name,
        :last_name,
        :institution,
        :city,
        :country,
        :website_url)
    end
end