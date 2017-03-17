module Stall
  module OmniauthHelper
    def user_omniauth_authorize_path_for(provider)
      send(:"user_#{ provider }_omniauth_authorize_path")
    end
  end
end
