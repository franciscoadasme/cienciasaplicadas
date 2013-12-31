class SiteController < ApplicationController
  before_action :set_pages
  before_action :set_lastest

  def index
    @page = @group.front_page
  end

  def about
    show_page @group.about_page
  end

  def people
    show_page @group.users_page
  end

  def projects
    show_page @group.projects_page
  end

  def publications
    show_page @group.pubs_page
  end

  def contact
  end

  def show
    show_page Page.friendly.find params[:page]
  end

  private
    def set_lastest
      @lastest_publications = Publication.unscoped.order(:created_at).limit(4)
      @lastest_posts = Post.published.limit(4)
    end

    def set_pages
      @pages = @group.unmarked_pages.published
    end

    def show_page(page)
      @page = page
      render action: :show
    end
end