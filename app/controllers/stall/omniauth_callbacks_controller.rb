module Stall
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    include Stall::OmniauthHelper

    # Pre-authorize request to store the redirect path, allowing users to get
    # back to the checkout wether the authentication is successful or not.
    #
    def redirect
      session['omniauth.after_sign_in_redirect_path'] = params[:_redirect_to] if params[:_redirect_to]
      redirect_to user_omniauth_authorize_path_for(params[:provider])
    end

    def facebook
      authenticate_user_from_oauth_callback!
    end

    def google_oauth2
      authenticate_user_from_oauth_callback!
    end

    private

    def authenticate_user_from_oauth_callback!
      user = Stall.config.service_for(:omniauth_user_authentication).new(auth.info.email, auth).call
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: auth.provider.humanize) if is_navigational_format?
    end

    def auth
      @auth ||= request.env['omniauth.auth']
    end

    def after_omniauth_failure_path_for(scope)
      redirect_path || new_session_path(scope)
    end

    def after_sign_in_path_for(scope)
      redirect_path || stored_location_for(scope) || root_path
    end

    def after_sign_up_path_for(scope)
      redirect_path || stored_location_for(scope) || root_path
    end

    def redirect_path
      session.delete('omniauth.after_sign_in_redirect_path')
    end
  end
end
