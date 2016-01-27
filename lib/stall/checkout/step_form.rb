module Stall
  module Checkout
    class StepForm
      include ActiveModel::Validations

      class_attribute :nested_forms

      attr_reader :step

      def initialize(step)
        @step = step
      end

      def self.nested(type, &block)
        self.nested_forms ||= {}
        nested_forms[type] = Class.new(StepForm, &block)
        nested_forms[type].step = step
      end

      def method_missing(method, *args, &block)
        step._validation_method_missing(method, *args, &block) || super
      end
    end
  end
end
