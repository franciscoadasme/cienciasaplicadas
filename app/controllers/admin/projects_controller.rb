class Admin::ProjectsController < AdminController
  before_action :authorize_user!, except: [ :index ]
  before_action :set_project, only: [ :edit, :update, :destroy ]
  before_action :set_users, only: [ :new, :create, :edit, :update ]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to admin_projects_path, success: tf('.success')
    else
      render action: 'new'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to admin_projects_path, success: tf('.success')
    else
      render action: 'edit'
    end
  end

  def destroy
    @project.destroy
    redirect_to admin_projects_url
  end

  private
    def authorize_user!
      redirect_to admin_projects_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def set_project
      @project = Project.find params[:id]
    end

    def set_users
      @users = User.unscoped.invitation_accepted.order :first_name, :last_name
      @external_users = ExternalUser.all
    end

    def project_params
      params.require(:project).permit(
        :title,
        :leader_id,
        :start_year,
        :end_year,
        :source,
        :identifier,
        :description,
        :image_url,
        { collaborator_ids: [] },
        { external_user_ids: [] }
      )
    end
end