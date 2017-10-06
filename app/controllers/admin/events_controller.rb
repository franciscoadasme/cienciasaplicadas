require 'zip'

class Admin::EventsController < AdminController
  include NotifiableController

  before_action :authorize_user!
  before_action :set_event, only: [:attendees, :show, :edit, :update, :destroy,
                                   :posts, :download_abstracts]

  def attendees
  end

  def download_abstracts
    redirect_to :attendees if @event.abstracts.submitted.empty?

    zip_path = Rails.root.join 'tmp', "#{@event.tagline}_abstracts.zip"
    compress_abstract_documents_at zip_path

    data = File.open(zip_path, 'rb+').read

    headers['Cache-Control'] = 'no-cache'
    send_data data, type: 'application/zip', filename: File.basename(zip_path)
    File.delete zip_path
  end

  def index
    @events = Event.sorted
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
    attendee = update_attendee_status accepted: true
    EventMailer.registration_accepted(attendee).deliver!
    redirect_to action: :attendees
  end

  def reject_attendee
    attendee = update_attendee_status accepted: false
    EventMailer.registration_rejected(attendee).deliver!
    redirect_to action: :attendees
  end

  def destroy_attendee
    attendee = fetch_attendee
    attendee.destroy
    redirect_to action: :attendees
  end

  def posts
    @posts = @event.posts.main.sorted
  end

  private

  def fetch_attendee
    Attendee.find params[:attendee_id]
  end

    def set_event
      @event = Event.eager_load(:attendees, :speakers, :posts)
                    .friendly.find(params[:id])
    end

    def event_params
      params.require(:event).permit(
        :name,
        :start_date,
        :end_date,
        :location,
        :description,
        :localized_description,
        :all_day,
        :event_type,
        :promoter,
        :picture,
        :managed,
        :registration_enabled,
        :max_attendee,
        :tagline,
        :abstract_section,
        :localized_abstract_section,
        :abstract_template,
        :abstract_deadline
      )
    end

  def compress_abstract_documents_at(pathname)
    Zip::File.open(pathname, Zip::File::CREATE) do |zipfile|
      @event.abstracts.submitted.each do |abstract|
        zipfile.get_output_stream(abstract.document_file_name) do |f|
          abstract.document.s3_object(nil).read { |chunk| f.write chunk }
        end
      end
    end
  end

  def update_attendee_status(accepted:)
    fetch_attendee.tap do |attendee|
      attendee.accepted = accepted
      attendee.save
    end
  end
end
