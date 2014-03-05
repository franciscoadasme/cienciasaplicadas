class Admin::AccountController < AdminController
  # GET /profile
  def edit
  end

  # PATCH/PUT /profile
  # PATCH/PUT /profile.json
  def update
    email_changed = current_user.email != account_params[:email]
    if current_user.update(account_params)
      redirect_to profile_admin_account_path, success: true, notice: email_changed
    else
      render action: 'edit'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:user).permit(
        :first_name,
        :last_name,
        :nickname,
        :email,
        :headline,
        :social_links,
        :bio,
        :image_url,
        :banner
      )
    end
end
