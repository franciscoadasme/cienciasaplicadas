module EventsHelper
  def banner_url_for_event_type(event_type)
    image_url "events/#{event_type}.jpg"
  end
end
