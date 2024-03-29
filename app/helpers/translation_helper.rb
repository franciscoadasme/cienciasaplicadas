module TranslationHelper
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

  def tv?(keypath)
    !tt(keypath, {}, 'views').start_with?('translation missing')
  end

  def ts(keypath, options={})
    tt keypath, { no_controller: true, no_action: true }.merge(options), 'views._sidebar'
  end

  # translate action
  def taction(keypath=nil, options={})
    keypath = [ controller_name, (keypath || action_name) ]
    keypath_alt = keypath[1..-1].unshift :defaults
    I18n.t keypath.join('.'), scope: [ :actions, :admin ], default: keypath_alt.join('.').to_sym
  end

# Sidebar
  def tsidebar(keypath, options = {})
    options[:scope] = [ :views, :admin, :_sidebar ].concat options.fetch(:scope, [])
    I18n.t keypath, options
  end

  def tsidebar_item(keypath, options = {})
    tsidebar keypath, options.merge(scope: [ :items ])
  end

  def tsidebar_hint(keypath, options = {})
    tsidebar keypath, options.merge(scope: [ :hints ])
  end
end