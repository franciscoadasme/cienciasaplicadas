class Admin::EventsController < AdminController
  include NotifiableController

  before_action :authorize_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
    @event.start_date = Date.today
    @positions = Position.sorted
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      send_new_notification_if_needed @event
      redirect_to [ :admin, @event ], success: true
    else
      @positions = Position.sorted
      render action: 'new'
    end
  end

  def update
    if @event.update(event_params)
      redirect_to [ :admin, @event ], success: true
    else
      render action: 'edit'
    end
  end

  def destroy
    @event.destroy
    redirect_to_index success: true
  end

  private
    def set_event
      @event = Event.friendly.find(params[:id])
    end

    def event_params
      params.require(:event).permit(
        :name,
        :start_date,
        :end_date,
        :location,
        :description,
        :all_day,
        :event_type,
        :promoter,
        :picture)
    end
end
