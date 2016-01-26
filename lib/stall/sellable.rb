module Stall
  module Sellable
    extend ActiveSupport::Concern

    included do
      has_many :line_items, class_name: 'Stall::LineItem',
                            dependent: :nullify,
                            as: :sellable,
                            inverse_of: :sellable
    end

    def to_line_item
      line_items.build(
        name: (respond_to?(:name) && name) || (respond_to?(:title) && title),
        unit_price: (respond_to?(:price) && price),
        unit_eot_price: eot_price,
        vat_rate: vat_rate,
      )
    end

    def vat_ratio
      (vat_rate / 100.0) + 1
    end

    private

    def default_eot_price
      price && (price / vat_ratio)
    end

    def default_vat_rate
      @default_vat_rate ||= Stall.config.vat_rate
    end

    def method_missing(name, *args, &block)
      if [:eot_price, :vat_rate].include?(name)
        send(:"default_#{ name }")
      else
        super
      end
    end
  end
end
