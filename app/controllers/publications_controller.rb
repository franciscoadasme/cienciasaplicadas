class PublicationsController < SiteController
  before_action :set_user
  def index
    @pubs = @user.publications.sorted
    @pubs_per_year = Hash[@pubs.group_by(&:year).map{ |y, ps| [y, ps.count] }]
  end

  private
    def set_user
      @user = User.friendly.find params[:user_id]
    end
end
