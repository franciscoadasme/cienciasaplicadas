class UsersController < SiteController
  before_action :set_user
  before_action :ensure_member
  decorates_assigned :publications, :user

  def publications_index
    @publications = @user.publications.includes({ authors: :user }, :journal)
                         .sorted
    @pubs_per_year = @user.statistics.publication_per_year.reverse
    render 'publications/index'
  end

  def show
    @user_pubs = @user.publications.flagged.sorted
    @user_pubs = @user.publications.sorted.limit(3) if @user_pubs.empty?
    @user_pubs = @user_pubs.includes(:authors, :journal).decorate
  end

  def stats
    @stats = @user.statistics
  end

  private

  def ensure_member
    return if @user.member?
    msg = I18n.t 'controllers.alerts.users.no_profile', user: user.display_name
    redirect_to :back, alert: msg
  end

  def set_user
    @user = User.includes(:projects, :thesis,
                          publications: [{ authors: :user }, :journal])
                .friendly.find(params[:user_id])
  end
end
