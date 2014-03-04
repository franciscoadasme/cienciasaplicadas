class Admin::ProjectsController < AdminController
  before_action :set_project, only: [ :edit, :update, :destroy ]
  before_action :authorize_user!, only: [ :edit, :update, :destroy ]

  def index
    @projects = current_user.projects
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    @project.user = current_user

    if @project.save
      redirect_to_index success: true
    else
      render action: 'new'
    end
  end

  def update
    if @project.update(project_params)
      redirect_to_index success: true
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
      redirect_to_index alert: :unauthorized unless @project.user_id == current_user.id
    end

    def set_project
      @project = Project.find params[:id]
    end

    def project_params
      params.require(:project).permit(
        :title,
        :start_year,
        :end_year,
        :source,
        :identifier,
        :description,
        :image_url,
        :position
      )
    end
end