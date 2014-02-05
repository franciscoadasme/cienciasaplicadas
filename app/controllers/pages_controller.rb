class PagesController < SiteController
  before_action :set_page

  def show
  end

  private
    def set_page
      @page = Page.friendly.find params[:id]
    end
end