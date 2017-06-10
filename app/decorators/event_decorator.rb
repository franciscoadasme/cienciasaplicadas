class EventDecorator < ContentDecorator
  delegate_all

  def date_span
    if one_day?
      h.time_tag start_date, l(start_date, format: :abbr_with_day)
    elsif start_date.month == end_date.month
      content = "#{start_date.day}–#{l end_date, format: :abbr_with_day}"
      h.time_tag start_date, content
    end
  end
end
