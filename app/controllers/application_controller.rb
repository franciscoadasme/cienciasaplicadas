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

    def content_for_flash(flash_options, flash_type)
      case flash_options
      when Symbol, Boolean, Hash
        keypaths = case flash_options
          when Symbol, Boolean then tkeypaths_for_flash(flash_options, flash_type)
          when Hash
            flash_name = flash_options.fetch :name, true
            tkeypaths_for_flash flash_name, flash_type, flash_options
        end
        options = { default: keypaths.second, scope: [ :controllers, controller_name ] }
        options.reverse_merge! flash_options if flash_options.is_a?(Hash)
        I18n.t keypaths.first, options
      else flash_options
      end
    end

    def tkeypaths_for_flash(flash_name, flash_type, options = {})
      scope = options.fetch :scope, [ options.fetch(:action, action_name), flash_type ]
      case flash_name
      when Boolean
        keypath = scope.dup.push(:default)
        keypath_alt = scope.dup
      when Symbol
        keypath = scope.dup.push flash_name
        keypath_alt = [ flash_type.to_s.pluralize, flash_name ]
      else
        raise ArgumentError.new('flash_name is neither a boolean nor a symbol')
      end
      [ keypath, keypath_alt ].map { |kp| kp.join('.').to_sym }
    end
end
