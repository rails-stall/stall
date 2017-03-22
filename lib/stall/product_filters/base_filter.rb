module Stall
  module ProductFilters
    class BaseFilter
      attr_reader :products

      def initialize(products)
        @products = products
      end

      def name
        key.gsub(/_filter/, '')
      end

      def label
        I18n.t("stall.products.filters.#{ key }")
      end

      def rendering_options(options = {})
        { partial: partial_path, locals: partial_locals }.deep_merge(options)
      end

      def partial_path
        "stall/products/filters/#{ key }"
      end

      def partial_locals
        { filter: self }
      end

      def key
        @key ||= self.class.name.demodulize.underscore
      end
    end
  end
end
