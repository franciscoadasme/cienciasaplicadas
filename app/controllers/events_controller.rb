class EventsController < SiteController
  def index
    @events = Event.during_date date_params

    @event_type_count = Hash[Event::TYPES.map(&:to_s).map{ |t| [t, 0]}]
    @event_type_count.merge! @events.group(:event_type).count

    @events = @events.typed params[:tipo] if params[:tipo]
    @events = @events.sorted
  end

  def show
    @event = Event.friendly.find params[:id]
  end
end
