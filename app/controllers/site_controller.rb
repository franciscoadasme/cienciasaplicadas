class SiteController < ApplicationController
  before_action :set_pages
  before_action :set_lastest

  def index
    @publication_count = Publication.count
    @publication_per_year = Publication.group(:year).count.values.mean

    @students_count = User.with_position('estudiante').count
    @graduated_users = User.with_position 'estudiante-egresado'
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
      @lastest_posts = Post.published.sorted.limit(4)
      @upcoming_events = Event.sorted.limit(3)
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
end