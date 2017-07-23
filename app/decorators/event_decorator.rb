class EventDecorator < ContentDecorator
  delegate_all

  def date_span
    content = if one_day?
                l(start_date, format: :abbr_with_day)
              elsif start_date.month == end_date.month
                "#{start_date.day}–#{l end_date, format: :abbr_with_day}"
              elsif start_date.year == end_date.year
                "#{l start_date, format: :abbr_with_day_no_year}–" \
                "#{l end_date, format: :abbr_with_day}"
              else
                "#{l start_date, format: :abbr_with_day}–" \
                "#{l end_date, format: :abbr_with_day}"
              end
    h.time_tag start_date, content
  end

  def event_type(locale = nil)
    locale ||= I18n.locale
    I18n.t event_type_i18n_key, locale: locale
  end

  private

  def event_type_i18n_key
    "activerecord.attribute_values.event.event_type.#{object.event_type}"
  end
end
