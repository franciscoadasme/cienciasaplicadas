class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:scope] == :user
      new_user_session_path
    else
      new_user_session_path
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end