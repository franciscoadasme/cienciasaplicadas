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
end
