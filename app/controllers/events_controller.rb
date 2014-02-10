class EventsController < SiteController
  def index
    @events = Event.sorted.during_date date_params
    @events = @events.typed params[:tipo] if params[:tipo]
  end

  def show
    @event = Event.friendly.find params[:id]
  end
end
