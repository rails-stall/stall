module Stall
  module Models
    module ProductCategory
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_product_categories'

        acts_as_tree order: 'position'
        class_attribute :max_depth

        extend FriendlyId
        friendly_id :name, use: [:slugged, :finders]
        
        has_many :products, dependent: :nullify

        validates :name, presence: true

        scope :ordered, -> { order(position: 'asc') }

        def self.max_depth
          2
        end

        def should_generate_new_friendly_id?
          slug.blank?
        end
      end
    end
  end
end
