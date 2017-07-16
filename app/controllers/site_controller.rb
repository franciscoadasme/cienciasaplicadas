class SiteController < ApplicationController
  if Rails.env.production?
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
  end

  before_action :set_pages
  before_action :set_lastest

  def index
    @publication_count = compute_publication_count
    @publication_per_year = compute_publication_avg_per_year

    @lastest_posts = Post.published.sorted.limit(3).decorate
    @upcoming_events = Event.upcoming.sorted.limit(3).decorate
    @students_count = User.with_position('estudiante').count
    @graduated_users = User.default.with_position('egresado').limit(3).decorate
    @graduate_count = User.with_position('egresado').count
    @recent_moments = Moment.sorted.limit(3).decorate
    @lastest_theses = Thesis.sorted.limit(3).decorate
    @lastest_publications = Publication.preload({ authors: :user }, :journal)
                                       .members_only
                                       .sorted
                                       .limit(6)
                                       .decorate
  end

  private
    def set_lastest
      unless view_context.current_page?(root_url) || view_context.current_page?(posts_url)
        @lastest_posts = Post.published.sorted.limit(2).decorate
      end
    end

    def set_pages
      @pages = Page.navigable
    end

    def render_not_found
      render 'site/not_found', status: 404, formats: :html
    end

  def compute_publication_count
    countable_publications.count
  end

  def compute_publication_avg_per_year
    countable_publications.group(:year).count.values.mean
  end

  def countable_publications
    @publications ||= begin
      slugs = ['director', 'profesor-claustro', 'estudiante']
      position_ids = Position.where(slug: slugs).pluck :id
      Publication.joins(:users).where('users.position_id' => position_ids)
    end
  end
end
