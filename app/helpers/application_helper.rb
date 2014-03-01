module ApplicationHelper
  def flash_class(level)
    case level
    when :notice then 'alert-info'
    when :alert then 'alert-warning'
    when :success then 'alert-success'
    when :error then 'alert-danger'
    end
  end

# Translation
  def tt(keypath, options={}, prefix=nil)
    no_action = options.delete :no_action
    no_controller = options.delete :no_controller
    keypath = (controller_name unless no_controller).to_s + (".#{params[:action]}" unless no_action).to_s + keypath if keypath.start_with? '.'
    keypath = "#{prefix}.#{keypath}" unless prefix.blank?
    I18n.t keypath, options
  end

  def tc(keypath, options={})
    tt keypath, options, 'controllers'
  end

  def tf(keypath, options={})
    keypath = '.flash' + keypath if keypath.start_with? '.'
    tc keypath, options
  end

  def tv(keypath, options={})
    tt keypath, options, 'views'
  end

  def ts(keypath, options={})
    tt keypath, { no_controller: true, no_action: true }.merge(options), 'views._sidebar'
  end
end