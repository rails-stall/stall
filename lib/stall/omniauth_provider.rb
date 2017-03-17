# This class is used as a config wrapper for devise's omniauth providers,
# allowing to easily configure new and existing providers.
#
module Stall
  class OmniauthProvider
    attr_reader :name, :config

    def initialize(name, config = nil)
      @name = name.to_s

      config ||= {}

      @icon = config.delete(:icon)
      @display_name = config.delete(:display_name)
      @app_id = config.delete(:app_id)
      @secret_key = config.delete(:secret_key)

      @config = config
    end

    def icon
      @icon ||= name
    end

    def display_name
      @display_name ||= name.humanize
    end

    def app_id
      @app_id ||= ENV["#{ constant_name }_APP_ID"]
    end

    def secret_key
      @secret_key ||= ENV["#{ constant_name }_SECRET_KEY"]
    end

    def constant_name
      @constant_name ||= name.to_s.upcase
    end
  end
end
