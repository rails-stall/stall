module Stall
  module Models
    module Manufacturer
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_manufacturers'

        acts_as_orderable

        has_many :products, dependent: :nullify

        has_attached_file :logo
        validates_attachment_content_type :logo, content_type: /\Aimage\/.*\Z/

        validates :name, presence: true
      end
    end
  end
end
