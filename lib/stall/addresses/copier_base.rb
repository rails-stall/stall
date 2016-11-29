module Stall
  module Addresses
    class CopierBase
      attr_reader :source, :target

      def initialize(source, target)
        @source = source
        @target = target
      end

      def copy
        fail NotImplementedError
      end

      private

      def duplicate_attributes(model)
        model.attributes.dup.tap do |attributes|
          %w(id type addressable_id addressable_type created_at updated_at).each do |key|
            attributes.delete(key)
          end
        end
      end
    end
  end
end
