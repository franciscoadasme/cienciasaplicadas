class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'site'

  include ApplicationHelper
  include UrlHelper
  include SessionsHelper
  add_flash_types :success, :error

  before_action :set_group
  before_action :store_location

  # testing
  before_action do
    params[:top_level_controller] = top_level_controller
    params[:current_path] = current_path
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
