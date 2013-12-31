class Admin::SettingsController < AdminController
  before_filter :set_settings

  def edit
  end

  def update
    if current_user.settings.update(settings_params)
      redirect_to settings_admin_account_path, success: t('settings.messages.update_successful')
    else
      render action: 'edit'
    end
  end

  private
    def settings_params
      params.require(:settings).permit(
        :update_attributes_by_provider,
        :update_nickname_by_provider,
        :update_image_by_provider,
        :show_contact_page,
        :deliver_notification_by_email,
        :autolink_on_import,
        :display_author_name,
        :include_lastname
      )
    end

    def set_settings
      @settings = current_user.settings
    end
end