module Stall
  module Models
    module Adjustment
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_adjustments'

        monetize :eot_price_cents, :price_cents,
                 with_model_currency: :currency, allow_nil: true

        belongs_to :cart

        delegate :currency, to: :cart, allow_nil: true

        validates :name, :price, :eot_price, :vat_rate, :cart, presence: true

        before_validation :fill_eot_price_and_vat_rate

        define_method(:eot_price) do
          if (eot_price = read_attribute(:eot_price)) && eot_price.to_f != 0
            eot_price
          else
            default_eot_price
          end
        end
      end

      def vat_rate
        read_attribute(:vat_rate) || Stall.config.vat_rate
      end

      def vat
        price - eot_price
      end

      private

      def fill_eot_price_and_vat_rate
        self.vat_rate = vat_rate
        self.eot_price = eot_price
      end

      def default_eot_price
        (price / (1.0 + (vat_rate / 100.0))) if price && vat_rate
      end
    end
  end
end
