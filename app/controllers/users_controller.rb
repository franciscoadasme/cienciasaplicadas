class UsersController < SiteController
  before_action :set_user, only: [ :show ]

  def show
    @user_pubs = @user.publications.flagged.sorted
    @user_pubs = @user.publications.sorted.limit(5) if @user_pubs.empty?
  end

  private
    def set_user
      @user = User.friendly.find params[:user_id]
    end
end