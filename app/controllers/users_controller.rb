class UsersController < SiteController
  before_action :set_user
  decorates_assigned :user

  def show
    @user_pubs = @user.publications.flagged.sorted
    @user_pubs = @user.publications.sorted.limit(3) if @user_pubs.empty?
    @user_pubs = @user_pubs.includes(:authors, :journal).decorate
  end

  def stats
    @stats = @user.statistics
  end

  private

  def set_user
    @user = User.includes(:projects, :publications, :thesis)
                .friendly.find(params[:user_id])
  end
end
