class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    from_omniauth :facebook
  end

  def google_oauth2
    from_omniauth :google
  end

  private
    def from_omniauth provider
      auth = request.env["omniauth.auth"]
      @user = User.from_omniauth(auth, current_user)

      if @user.nil?
        redirect_to new_user_session_path, alert: "No user was found with email \"#{auth[:info][:email]}\"."
      else
        unless @user.accepted?
          @user.accept_invitation!
        end
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: provider.to_s.titleize if is_navigational_format?
        sign_in_and_redirect @user, event: :authentication
      end
    end
end