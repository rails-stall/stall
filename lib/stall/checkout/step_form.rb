module Stall
  module Checkout
    class StepForm
      include ActiveModel::Validations

      class_attribute :nested_forms

      attr_reader :target, :step

      delegate :errors, to: :target

      def initialize(target, step)
        @target = target
        @step = step
      end

      def validate
        super && validate_nested_forms
      end

      def self.nested(type, &block)
        self.nested_forms ||= {}
        nested_forms[type] = build(&block)
      end

      def self.build(&block)
        Class.new(StepForm, &block)
      end

      def method_missing(method, *args, &block)
        if target.respond_to?(method)
          target.send(method, *args, &block)
        else
          step._validation_method_missing(method, *args, &block) || super
        end
      end

      # Override model name instanciation to add a name, since the form classes
      # are anonymous, and ActiveModel::Name does not support unnamed classes
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, target.class.name)
      end

      private

      def validate_nested_forms
        # If no nested forms are present in the class, just return true since
        # no validation should be tested
        return true unless self.class.nested_forms

        # Run all validations on all nested forms and ensure they're all valid
        self.class.nested_forms.all? do |name, form|
          if target.respond_to?(name) && (model = target.send(name))
            Array.wrap(model).all? { |m| form.new(m, step).validate }
          else
            # Nested validations shouldn't be run on undefined relations
            true
          end
        end
      end
    end
  end
end
