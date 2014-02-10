module MomentsHelper
  def moment_permalink(moment)
    return moment if moment.blank?
    date = moment.taken_on
    moment_path id: moment.id, year: date.year, month: date.month, day: date.day
  end
end
