class EventsController < SiteController
  decorates_assigned :events, :event

  def index
    @events = Event.during_date date_params
    set_event_type_counts

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted
    @events.reverse_order if date_params.blank?
  end

  def show
    @event = Event.friendly.find params[:id]
  end

  def upcoming
    @events = Event.upcoming
    set_event_type_counts

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted

    render action: :index
  end

  private

  def set_event_type_counts
    @event_type_count = Hash[Event::TYPES.map(&:to_s).map{ |t| [t, 0]}]
    @event_type_count.merge! @events.group(:event_type).count
  end
end
