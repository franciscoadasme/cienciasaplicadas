module DateHelper
  def format_date(date, format = :default)
    today = DateTime.current.to_date
    case
    when (date - today).abs <= 1
      tkey = case date
        when today then :today
        when today.yesterday then :yesterday
        when today.tomorrow then :tomorrow
      end
      I18n.t('date.relative_day_names')[tkey]
    else
      I18n.l date, format: format
    end
  end

  def format_period(start_date, end_date)
    return I18n.l(start_date, format: :short) if end_date.nil?

    same_year = start_date.year == end_date.year
    same_month = same_year && start_date.month == end_date.month
    same_day = same_month && start_date.day == end_date.day

    is_current_year = start_date.year == DateTime.current.year
    result = case
      when same_day
        I18n.l start_date, format: :short
      when same_month
        tkey = "period.formats.same_month#{'_with_year' unless is_current_year}"
        I18n.t tkey, start_day: start_date.day, end_day: end_date.day, month: I18n.l(start_date, format: :month).titleize, year: start_date.strftime("'%y")
      when same_year
        tkey = "period.formats.same_year#{'_with_year' unless is_current_year}"
        I18n.t tkey, start_date: I18n.l(start_date, format: :short), end_date: I18n.l(end_date, format: :short), year: start_date.strftime("'%y")
      else
        I18n.t 'period.formats.long', start_date: I18n.l(start_date, format: :abbr_with_day), end_date: I18n.l(end_date, format: :abbr_with_day)
    end

    regexp = Regexp.union I18n.t('period.formats.connectors')
    result.gsub(regexp) { |match| content_tag :span, match, class: 'text-muted' }.html_safe
  end
end