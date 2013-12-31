class ProjectsController < SiteController
  before_action :set_project

  def show
  end

  private
    def set_project
      project_id = params[:id]
      if params.has_key?(:project_id)
        @user = User.friendly.find(params[:id])
        @user_pages = @user.pages.published
        project_id = params[:project_id]
      end
      @project = Project.find project_id
    end
end