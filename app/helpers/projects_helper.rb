module ProjectsHelper
  def project_timespan(project)
    return nil unless project.has_timespan?
    timespan = project.start_year.to_s
    if project.end_year.present?
      timespan << ' a '
      timespan << project.end_year.to_s
    end
    timespan
  end
end
