class PublicationsController < SiteController
  before_action :set_user
  decorates_assigned :publications, :user

  def index
    @publications = @user.publications.includes(:authors, :journal).sorted
    @pubs_per_year = @user.statistics.publication_per_year.reverse
  end

  private

  def set_user
    @user = User.includes(:projects, :publications, :thesis)
                .friendly.find params[:user_id]
  end
end
