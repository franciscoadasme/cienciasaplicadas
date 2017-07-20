class EventsController < SiteController
  before_action :set_event, only: [:show, :registration]
  before_action :ensure_subscribable, only: [:registration]
  decorates_assigned :events, :event

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
    @events = @events.sorted

    render action: :index
  end

  def current_month
    @events = Event.during_date month: Time.zone.now.month
    set_event_type_counts

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted

    render action: :index
  end

  def registration
    if params.key?(:attendee)
      @attendee = Attendee.new attendee_params
      @attendee.event = @event
      if @attendee.save
        flash[:success] = 'Registro en el evento completado'
        redirect_to event_url(@event)
      end
    else
      @attendee = Attendee.new
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit(:email, :name)
  end

  def ensure_subscribable
    return if @event.subscribable?
    msg = I18n.t 'controllers.admin.events.alerts.registration_disabled'
    redirect_to event_url(@event), alert: msg
  end

  def set_event
    @event = Event.friendly.find params[:id]
  end

  def set_event_type_counts
    @event_type_count = Hash[Event::TYPES.map(&:to_s).map{ |t| [t, 0]}]
    @event_type_count.merge! @events.group(:event_type).count
  end
end
