class ProjectsController < SiteController
  before_action :set_user
  decorates_assigned :project, :projects, :user

  def index
    @projects = @user.projects.sorted
  end

  def show
    @project = Project.find params[:id]
  end

  private

  def set_user
    @user = User.includes(:projects, :publications, :thesis)
                .friendly.find(params[:user_id])
  end
end
