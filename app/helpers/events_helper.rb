module EventsHelper
  def banner_url_for_event_type(event_type)
    image_url "events/#{event_type}.jpg"
  end

  def event_nav_widget
    today = DateTime.current.to_date
    start_month = today.advance(months: -1)
    end_month = today.advance(months: 6)
    items = [
      { title: I18n.t('views.nav.date.upcoming'), path: upcoming_events_path }
    ]
    nav_date_widget start_month, end_month, :events_path, 1.month, items
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
