class PublicationsController < SiteController
  before_action :set_user
  def index
    @pubs = @user.publications.sorted
    @years = @pubs.pluck(:year).uniq
  end

  private
    def set_user
      @user = User.friendly.find params[:user_id]
    end
end
