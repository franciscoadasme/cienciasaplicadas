class SiteController < ApplicationController
  before_action :set_pages
  before_action :set_lastest

  def index
    @publication_count = Publication.count
    @posts = Post.limit(3)
    @graduated_user = User.find_by email: 'camila.munoz20@gmail.com'
  end

  def contact
  end

  def show
    show_page Page.named params[:page]
  end

  private
    def set_lastest
      @lastest_publications = Publication.unscoped.order(:created_at).limit(4)
      @lastest_posts = Post.published.limit(4)
    end

    def set_pages
      @pages = Page.navigable
    end

    def show_page(page)
      @page = page
      render action: :show
    end
end