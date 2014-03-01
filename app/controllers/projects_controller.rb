class ProjectsController < SiteController
  before_action :set_user

  def index
    @projects = @user.projects
    @projects_range = @projects.maximum(:end_year).downto @projects.minimum(:start_year)

    if params.has_key? :year
      year = params[:year].to_i
      @projects = @projects.where 'start_year <= ? AND end_year >= ?', year, year
    end
    @positions = @projects.group(:position).count

    @projects = @projects.sorted
  end

  def show
    @project = Project.find params[:id]
  end

  private
    def set_user
      @user = User.friendly.find params[:user_id]
    end
end