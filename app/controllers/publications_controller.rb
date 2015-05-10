class PublicationsController < SiteController
  before_action :set_user
  def index
    @pubs = @user.publications.includes(:authors, :journal).sorted
    @pubs_per_year = @user.statistics.publication_per_year.reverse
  end

  private

  def set_user
    @user = User.friendly.find params[:user_id]
  end
end
