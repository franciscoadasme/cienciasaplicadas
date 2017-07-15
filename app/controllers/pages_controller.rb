class PagesController < SiteController
  before_action :set_user, only: [:show]
  before_action :set_page, only: [:show]
  decorates_assigned :page

  def show
  end

  def research
    @page = Page.friendly.find 'investigacion'
    @publications = Publication.preload({ authors: :user }, :journal)
                               .members_only
                               .sorted
                               .first(10)
    @theses = Thesis.includes(:user).sorted.decorate.first(5)
  end

  private
    def set_page
      @page = Page.friendly.find params[:id]
    end

    def set_user
      @user = User.friendly.find params[:user_id] if params.has_key? :user_id
    end
end
