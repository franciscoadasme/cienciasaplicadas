class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_action do
    redirect_to admin_path, alert: t('devise.failure.unauthorized') if top_level_controller?(:group) && !current_user.super_user?
  end

  layout 'admin'

  def dashboard
    last_seven_days = DateTime.current.advance(days: -7)
    @recent_users = User.where('invitation_accepted_at >= ?', last_seven_days)
    @pending_users = User.invitation_not_accepted.where('invitation_sent_at >= ?', last_seven_days)
    @recent_publications = Publication.limit(5)
    @recent_pages = @group.pages.where('updated_at >= ?', last_seven_days)
  end
end