module Stall
  module Models
    module Address
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_addresses'

        has_one :address_ownership, dependent: :destroy

        enum civility: { :m => 1, :mme => 2 }

        def self.civility_enum
          civilities.each_with_object({}) do |(key, value), hash|
            hash[I18n.t("stall.addresses.civilities.#{ key }")] = key
          end
        end

        def civility_name
          I18n.t("stall.addresses.civilities.#{ civility }")
        end

        def country_name
          if (country = ISO3166::Country[country_code])
            country.translations[I18n.locale.to_s] || country.name
          end
        end
      end
    end
  end
end
