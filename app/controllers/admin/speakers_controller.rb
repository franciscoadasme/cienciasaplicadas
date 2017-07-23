class Admin::SpeakersController < AdminController
  before_action :set_event
  before_action :set_speaker, only: [:edit, :update, :destroy]
  decorates_assigned :speakers

  def index
    @speakers = @event.speakers.sorted
  end

  def new
    @speaker = Speaker.new event: @event
  end

  def create
    @speaker = Speaker.new speaker_params.merge(event: @event)
    if @speaker.save
      redirect_to admin_event_speakers_path(@event)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @speaker.update(speaker_params)
      redirect_to admin_event_speakers_path(@event)
    else
      render action: 'edit'
    end
  end

  def destroy
    @speaker.destroy
    redirect_to admin_event_speakers_path(@event)
  end

  private

  def set_event
    @event = Event.friendly.find params[:event_id]
  end

  def set_speaker
    @speaker = Speaker.find params[:id]
  end

  def speaker_params
    params.require(:speaker).permit :name, :description, :institution, :photo,
                                    :website_url
  end
end
