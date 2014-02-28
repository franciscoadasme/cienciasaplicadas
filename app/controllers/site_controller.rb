class SiteController < ApplicationController
  before_action :set_pages
  before_action :set_lastest

  def index
    @publication_count = Publication.count
    @publication_per_year = Publication.group(:year).count.values.mean

    @students_count = User.with_position('estudiante').count
    @graduated_users = User.with_position 'estudiante-egresado'
    @recent_moments = Moment.sorted.limit(3)
  end

  def contact
  end

  private
    def set_lastest
      @lastest_publications = Publication.unscoped.order(created_at: :desc).limit(3)
      @lastest_posts = Post.published.sorted.limit(3)
      @upcoming_events = Event.sorted.limit(3)
    end

    def set_pages
      @pages = Page.navigable
    end
end