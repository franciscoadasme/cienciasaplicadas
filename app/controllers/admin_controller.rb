class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_action do
    redirect_to admin_path, alert: t('devise.failure.unauthorized') if top_level_controller?(:group) && !current_user.super_user?
  end

  before_action :set_locale
  after_action :restore_locale

  layout 'admin'

  def dashboard
    last_seven_days = DateTime.current.advance(days: -7)
    @recent_users = User.where('invitation_accepted_at >= ?', last_seven_days)
    @pending_users = User.invitation_not_accepted.where('invitation_sent_at >= ?', last_seven_days)
    @recent_publications = Publication.limit(5)
  end

  protected
    def redirect_to_index(response_status = {})
      redirect_to [ :admin, controller_name ], response_status
    end

  private
    def authorize_user!
      redirect_to admin_path, alert: t('devise.failure.unauthorized') unless current_user.super_user?
    end

    def set_locale
      I18n.locale = :en
    end

    def restore_locale
      I18n.locale = 'es-CL'
    end
end