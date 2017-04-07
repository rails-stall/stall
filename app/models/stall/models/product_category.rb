module Stall
  module Models
    module ProductCategory
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_product_categories'

        acts_as_tree order: 'position'

        extend FriendlyId
        friendly_id :name, use: [:slugged, :finders]

        has_many :products, dependent: :nullify

        validates :name, presence: true

        scope :ordered, -> { order(position: 'ASC') }
      end

      def all_child_products
        ::Product.where(product_category_id: ([id] + descendant_ids))
      end

      module ClassMethods
        def max_depth
          2
        end
      end
    end
  end
end
