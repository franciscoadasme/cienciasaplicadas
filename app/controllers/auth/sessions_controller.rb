class Auth::SessionsController < Devise::SessionsController
  layout 'admin'

  after_action :unset_provider, only: [ :create ]

  private
    def unset_provider
      current_user.update provider: nil, uid: nil
    end
end