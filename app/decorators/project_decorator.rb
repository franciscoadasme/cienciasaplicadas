class ProjectDecorator < Draper::Decorator
  delegate_all

  def identifier
    "No. #{object.identifier}"
  end

  def source_and_id
    "#{object.source} No. #{object.identifier}"
  end

  def timespan
    return start_year.to_s unless project.end_year.present?
    "#{start_year} a #{end_year}"
  end

  def viewable?
    object.description.present?
  end
end
