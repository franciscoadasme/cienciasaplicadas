module UrlHelper
  def action_name
    params[:action]
  end

  def action? name
    action_name == name.to_s
  end

  def controller_name
    params[:controller].split('/').last rescue ''
  end

  def controller? name
    controller_name == name.to_s
  end

  def current_path record=nil
    begin
      path = request.original_fullpath.gsub('/admin/', '')
        .gsub(/(?<=#{controller_name}).+(?=#{action_name})/, '/')
        .gsub(/\/(?=#{action_name})/, '#')
      path << "##{action_name}" unless path.include?(action_name)
      # Since some routes can belong to a parent controller, we need the record to retrieve its parent controller name due to shallow route nesting
      path.prepend("#{record.associated_controller}/") if !record.nil? && !path.include?('/')
      path
    rescue
      ''
    end
  end

  def current_path? path, record=nil
    current_path(record).start_with? path
  end

  def split_path path
    path.prepend('/') unless path.include?('/')
    components = path.split(/[\/#]/).map { |i| i.blank? ? nil : i }
    Hash[ %w(top_level_controller controller action).zip(components) ].symbolize_keys
  end

  def top_level_controller
    split_path(current_path)[:top_level_controller]
  end

  def top_level_controller? name
    top_level_controller == name.to_s
  end

  def translate_path path, record=nil
    components = split_path(path)
    expression = ":controller_path"
    expression.prepend "#{components[:top_level_controller]}_" unless components[:top_level_controller].blank?
    expression.prepend "admin_"
    expression.prepend "#{components[:action]}_" unless [ nil, 'index', 'update', 'create', 'destroy' ].include?(components[:action])
    begin
      send expression.gsub(':controller', components[:controller])
    rescue
      send expression.gsub(':controller', components[:controller].singularize), id: (record.id unless record.nil?)
    end
  end

  def external_user_path(user)
    user.website_url
  end
end