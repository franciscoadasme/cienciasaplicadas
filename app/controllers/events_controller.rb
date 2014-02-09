class EventsController < SiteController
  include Filterable

  def index
    @events = Event.sorted.during_date date_params
    @events = @events.typed params[:tipo] if params[:tipo]
  end
end
