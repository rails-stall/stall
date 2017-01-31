module Stall
  module Models
    module Address
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_addresses'

        belongs_to :addressable, polymorphic: true

        enum civility: { :m => 1, :mme => 2 }

        def self.civility_enum
          civilities.each_with_object({}) do |(key, value), hash|
            hash[I18n.t("stall.addresses.civilities.#{ key }")] = key
          end
        end

        def civility_name
          I18n.t("stall.addresses.civilities.#{ civility }") if civility.present?
        end

        def country_name
          if iso_country
            iso_country.translations[I18n.locale.to_s] || iso_country.name
          end
        end

        def state_name
          iso_state['name'] if iso_state
        end

        private

        def iso_country
          @iso_country ||= country && ISO3166::Country[country]
        end

        def iso_state
          @iso_state ||= iso_country.subdivisions[state] if iso_country && state
        end
      end
    end
  end
end
