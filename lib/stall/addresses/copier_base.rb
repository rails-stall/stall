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
          attributes.delete('id')
        end
      end
    end
  end
end
