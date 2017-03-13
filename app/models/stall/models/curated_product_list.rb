module Stall
  module Models
    module CuratedProductList
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_curated_product_lists'

        has_many :curated_list_products, -> { ordered }
        has_many :products, through: :curated_list_products

        accepts_nested_attributes_for :curated_list_products,
          allow_destroy: true

        extend FriendlyId
        friendly_id :name, use: [:slugged, :finders]
      end
    end
  end
end
