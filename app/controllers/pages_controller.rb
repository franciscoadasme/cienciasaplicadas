class PagesController < SiteController
  before_action :set_user
  before_action :set_page
  decorates_assigned :page

  def show
  end

  private
    def set_page
      @page = Page.friendly.find params[:id]
    end

    def set_user
      @user = User.friendly.find params[:user_id] if params.has_key? :user_id
    end
end