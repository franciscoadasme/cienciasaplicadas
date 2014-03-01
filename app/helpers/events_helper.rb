module EventsHelper
  def banner_url_for_event_type(event_type)
    image_url "events/#{event_type}.jpg"
  end

  def nav_header_data_for_event(event)
    data = {}
    data[:prev] = {
      href: @event.previous,
      title: 'Ir al evento anterior'
    } if @event.previous.present?
    data[:next]= {
      href: @event.next,
      title: 'Ir al siguiente evento'
    } if @event.next.present?
    data
  end
end
