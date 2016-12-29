class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_action do
    redirect_to admin_path, alert: t('devise.failure.unauthorized') if top_level_controller?(:group) && !current_user.super_user?
  end

  layout 'admin'

  def index
    redirect_to index_path_for_current_user
  end

  def dashboard
    last_seven_days = DateTime.current.advance(days: -7)
    @recent_users = User.where('invitation_accepted_at >= ?', last_seven_days)
    @pending_users = User.invitation_not_accepted.where('invitation_sent_at >= ?', last_seven_days)
    @recent_publications = Publication.limit(5)
  end

  protected
    def tkeypaths_for_flash(flash_options)
      flash_options[:namespace] ||= :admin
      super
    end

    def redirect_to_index(response_status = {})
      redirect_to [ :admin, controller_name ], response_status
    end

  private
    def authorize_user!
      redirect_to admin_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

  def index_path_for_current_user
    current_user.super_user? ? admin_users_path : profile_admin_account_path
  end
end
