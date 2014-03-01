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

  protected
    def redirect_to(options = {}, response_status = {})
      [ :alert, :notice, :success, :error ].each do |flash_type|
        flash = response_status[flash_type]
        next unless flash.present?

        content = case flash
          when String then flash
          else
            tkey = flash.is_a?(Symbol) ? flash : flash_type
            keypath = "controllers.#{controller_name}.#{action_name}.#{tkey}"
            I18n.t(keypath)
        end
        response_status[flash_type] = content
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
end
