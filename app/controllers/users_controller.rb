class UsersController < SiteController
  before_action :set_user

  def show
    @user_pubs = @user.publications.flagged.sorted
    @user_pubs = @user.publications.sorted.limit(5) if @user_pubs.empty?
    @user_pubs.includes(:authors, :journal)
  end

  def stats
  end

  private
    def set_user
      @user = User.friendly.find params[:user_id]
    end
end
