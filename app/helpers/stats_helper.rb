module StatsHelper
  def format_impact_factor(value)
    value.nil? || value.zero? ? '?' : value.round(2)
  end
end