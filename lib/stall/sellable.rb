module Stall
  module Sellable
    extend ActiveSupport::Concern

    included do
      has_many :line_items, dependent: :nullify,
                            as: :sellable,
                            inverse_of: :sellable
    end

    def to_line_item
      line_items.build(
        name: (try(:name) || try(:title)),
        unit_price: try(:price),
        unit_eot_price: eot_price,
        vat_rate: vat_rate,
      )
    end

    def vat_ratio
      (vat_rate / 100.0) + 1
    end

    def currency
      Money.default_currency
    end

    private

    def default_eot_price
      if (price = try(:price))
        price / vat_ratio
      end
    end

    def default_vat_rate
      @default_vat_rate ||= Stall.config.vat_rate
    end

    # Create default handlers for the `#eot_price` and `#vat_rate` methods that
    # don't need to be explictly defined if the whole shop has a single VAT rate
    # for all products
    #
    def method_missing(name, *args, &block)
      if [:eot_price, :vat_rate].include?(name)
        send(:"default_#{ name }")
      else
        super
      end
    end
  end
end
