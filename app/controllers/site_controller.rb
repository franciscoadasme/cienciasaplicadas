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

    @students_count = User.with_position('estudiante').count
    @graduate_users = User.default.with_position 'egresado'
    @graduate_count = User.with_position('egresado').count
    @recent_moments = Moment.sorted.limit(3)
    @lastest_theses = Thesis.sorted.limit(3)
  end

  def contact
    if params.has_key?(:contact_message)
      @message = ContactMessage.new contact_params
      if @message.valid?
        @message.deliver!
        @message = ContactMessage.new
        flash.now[:success] = 'Mensaje enviado satisfactoriamente. Usted recibirá una respuesta dentro de los próximos días en la dirección de correo electrónico ingresada. Gracias por su interés.'
      else
        flash.now[:error] = 'Oh lo siento! Uno o más campos son inválidos. Favor verifica los datos e intenta enviar de nuevo.'
      end
    else
      @message = ContactMessage.new
      @presentation_page = Page.named(:presentacion)
      @future_students_page = Page.named(:futurosestudiantes)
    end
  end

  private
    def set_lastest
      @lastest_publications = Publication.unscoped.order(created_at: :desc).limit(3)
      @lastest_posts = Post.published.sorted.limit(3).decorate
      @upcoming_events = Event.upcoming.sorted.limit(3).decorate
    end

    def set_pages
      @pages = Page.navigable
    end

    def contact_params
      params.require(:contact_message).permit(
        :first_name,
        :last_name,
        :email,
        :body,
        :as_student)
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
