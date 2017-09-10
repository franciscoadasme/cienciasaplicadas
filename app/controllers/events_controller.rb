class EventsController < SiteController
  # TODO: make this global
  before_action :set_locale, only: [:show, :posts, :registration, :speakers,
                                    :abstracts]
  before_action :set_event, only: [:show, :posts, :registration, :speakers,
                                   :abstracts]
  before_action :ensure_managed, only: [:posts, :speakers, :abstracts]
  before_action :ensure_subscribable, only: [:registration, :abstracts]
  decorates_assigned :events, :event, :posts, :speakers

  def index
    @events = Event.during_date date_params
    set_event_type_counts

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted
    @events.reverse_order if date_params.blank?
  end

  def show; end

  def upcoming
    @events = Event.upcoming
    set_event_type_counts

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted.reverse_order

    render action: :index
  end

  def current_month
    @events = Event.during_date month: Time.zone.now.month
    set_event_type_counts

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted

    render action: :index
  end

  def posts
    @posts = PostDecorator.decorate_collection @event.posts.locale(I18n.locale).sorted
  end

  def registration
    if params.key?(:attendee)
      @attendee = Attendee.new attendee_params
      if @attendee.save
        flash[:success] = I18n.t 'controllers.success.events.registration'
        redirect_to event_url(@event, request.query_parameters)
      end
    else
      @attendee = Attendee.new
    end
  end

  def speakers
    @speakers = SpeakerDecorator.decorate_collection @event.speakers.sorted
  end

  def abstracts; end

  private

  def attendee_params
    params.require(:attendee).permit(:email, :name).merge(
      event: @event,
      locale: I18n.locale
    )
  end

  def ensure_managed
    redirect_to event_url(@event) unless @event.managed?
  end

  def ensure_subscribable
    return if @event.subscribable?
    msg = I18n.t 'controllers.admin.events.alerts.registration_disabled'
    redirect_to event_url(@event), alert: msg
  end

  def set_event
    @event = Event.includes(:posts, :speakers)
                  .friendly.find params[:id].downcase
  end

  def set_event_type_counts
    @event_type_count = Hash[Event::TYPES.map(&:to_s).map{ |t| [t, 0]}]
    @event_type_count.merge! @events.group(:event_type).count
  end

  def set_locale
    I18n.locale = params[:lang] || I18n.default_locale
  end
end
