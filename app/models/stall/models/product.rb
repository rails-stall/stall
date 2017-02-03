module Stall
  module Models
    module Product
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_products'

        acts_as_orderable
        extend FriendlyId
        friendly_id :name, use: [:slugged, :finders]

        belongs_to :product_category

        has_many :variants, dependent: :destroy, inverse_of: :product
        accepts_nested_attributes_for :variants, allow_destroy: true

        has_many :product_details, dependent: :destroy, inverse_of: :product
        accepts_nested_attributes_for :product_details, allow_destroy: true

        has_attached_file :image, styles: {
          thumb: '100x100#',
          show: '555x'
        }

        validates :name, :image, presence: true
        validates_attachment :image, content_type: { content_type: /\Aimage\/.*\z/ }

        scope :visible, -> { where(visible: true) }

        def should_generate_new_friendly_id?
          slug.blank?
        end

        def vat_rate
          Stall.config.vat_rate
        end

        def price
          variants.map(&:price).min
        end
      end
    end
  end
end
