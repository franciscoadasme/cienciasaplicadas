class MomentDecorator < Draper::Decorator
  delegate_all

  def permalink
    date = object.taken_on
    h.moment_path id: object.id, year: date.year, month: date.month,
                  day: date.day
  end

  def time_tag
    h.time_tag taken_on,
               l(taken_on, format: :abbr_with_day),
               pubdate: true
  end
end
