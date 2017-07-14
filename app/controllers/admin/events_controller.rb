class Admin::EventsController < AdminController
  include NotifiableController

  before_action :authorize_user!
  before_action :set_event, only: [:attendees, :show, :edit, :update, :destroy]

  def attendees
  end

  def index
    @events = Event.sorted.reverse
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

  def accept_attendee
    update_attendee_status accepted: true
  end

  def reject_attendee
    update_attendee_status accepted: false
  end

  def destroy_attendee
    attendee = fetch_attendee
    attendee.destroy
    redirect_to action: :attendees
  end

  private

  def fetch_attendee
    Attendee.find params[:attendee_id]
  end

    def set_event
      @event = Event.includes(:attendees).friendly.find(params[:id])
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

  def update_attendee_status(accepted:)
    attendee = fetch_attendee
    attendee.accepted = accepted
    attendee.save
    redirect_to action: :attendees
  end
end
