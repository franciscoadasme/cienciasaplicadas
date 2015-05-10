module StatsHelper
  def format_impact_factor(value)
    value.nil? || value.zero? ? '?' : value.round(2)
  end

  def pub_stat_item(count, text = '')
    text = 'publicación'.pluralize(count, :'es-CL') + ' ' + text
    stat_item count, text.strip
  end

  def stat_item(count, text)
    content_tag :li, class: 'stat' do
      concat(content_tag(:div, class: 'shelf') do
        content_tag :span, count, class: 'stat-number'
      end)
      concat content_tag(:span, text, class: 'stat-label')
    end
  end
end
