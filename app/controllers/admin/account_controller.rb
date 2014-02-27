class Admin::AccountController < AdminController
  # GET /profile
  def edit
  end

  # PATCH/PUT /profile
  # PATCH/PUT /profile.json
  def update
    if current_user.update(account_params)
      flash[:notice] = 'Beware that you must use the new email address to sign in the next time.'
      redirect_to profile_admin_account_path, success: 'Profile was successfully updated.'
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
        :signature,
        :bio,
        :image_url,
        :banner
      )
    end
end
