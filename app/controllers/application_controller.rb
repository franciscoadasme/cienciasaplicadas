class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'site'

  include ApplicationHelper
  include TranslationHelper
  include UrlHelper
  include SessionsHelper
  add_flash_types :success, :error

  before_action :set_group
  before_action :store_location

  def redirect_to(options = {}, response_status = {})
    [ :alert, :notice, :success, :error ].each do |flash_type|
      flash_options = response_status[flash_type]
      next unless flash_options.present?

      response_status[flash_type] = content_for_flash flash_options, flash_type
    end
    super
  end

  def redirect_to_index(response_status = {})
    redirect_to [ controller_name ], response_status
  end

  protected
    def content_for_flash(flash_options, flash_type)
      return flash_options if flash_options.is_a?(String)

      flash_options = { name: flash_options } unless flash_options.is_a?(Hash)
      flash_options[:name] ||= true
      flash_options[:type] = flash_type

      keypaths = tkeypaths_for_flash flash_options
      options = { default: keypaths.pop, scope: [ :controllers, flash_options[:namespace], controller_name ].compact }
      options.reverse_merge! flash_options
      I18n.t keypaths.shift, options
    end

    def tkeypaths_for_flash(flash_options)
      scope = flash_options.fetch :scope, [ flash_options.fetch(:action, action_name), flash_options[:type] ]
      case flash_options[:name]
      when Boolean
        keypath = scope.dup.push(:default)
        keypath_alt = scope.dup
      when Symbol
        keypath = scope.dup.push flash_options[:name]
        keypath_alt = [ flash_options[:type].to_s.pluralize, flash_options[:name] ]
      else
        raise ArgumentError.new('flash name is neither a boolean nor a symbol')
      end
      [ keypath, keypath_alt ].map { |kp| kp.join('.').to_sym }
    end

  private
    def set_group
      @group = Group.first
    end

    def after_sign_in_path_for(resource)
      logger.debug "PREVIOUS_URL: #{session[:previous_url]}"
      session.delete(:previous_url) || admin_path
    end

    def store_location
      if (request.fullpath != "/auth/sign_in" &&
          request.fullpath != "/auth/sign_up" &&
          request.fullpath != "/auth/password" &&
          !request.fullpath.match(/\/auth\/.+/) &&
          !request.fullpath.match(/\/invitation\/accept.+/) &&
          request.fullpath != "/admin/users/invitation" &&
          !request.fullpath.match(/.+mailer.+/) &&
          !request.fullpath != '/admin/pages/sort' &&
          request.fullpath != "/")
        session[:previous_url] = request.fullpath
        logger.debug "PREVIOUS_URL: #{session[:previous_url]}"
      end
    end
end
