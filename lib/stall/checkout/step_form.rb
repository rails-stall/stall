module Stall
  module Checkout
    class StepForm
      include ActiveModel::Validations

      class_attribute :nested_forms

      attr_reader :object, :step, :clear_cart_errors_before_validation

      delegate :errors, to: :object

      def initialize(object, step, clear: true)
        @object = object
        @step = step
        @clear_cart_errors_before_validation = clear
      end

      # Runs form and nested forms validations and returns wether they all
      # passed or not
      #
      # Only clear validation errors on the cart if needed, allowing to run
      # cart validations before the step ones, passing clear: false in the
      # form constructor, aggregating both validation sources' errors
      #
      def validate
        errors.clear if clear_cart_errors_before_validation
        run_validations!
        validate_nested_forms
        !errors.any?
      end

      def self.nested(type, &block)
        self.nested_forms ||= {}
        nested_forms[type] = build(&block)
      end

      # Build an dynamic StepForm subclass with the given block as the body
      # of the class
      #
      def self.build(&block)
        Class.new(StepForm, &block)
      end

      def method_missing(method, *args, &block)
        if object.respond_to?(method, true)
          object.send(method, *args, &block)
        elsif step.respond_to?(method, true)
          step.send(method, *args, &block)
        else
          super
        end
      end

      # Override model name instanciation to add a name, since the form classes
      # are anonymous, and ActiveModel::Name does not support unnamed classes
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, self.class.name)
      end

      private

      # Validates all registered nested forms
      #
      # Note : We use `forms.map.all?` instead if `forms.all?` to ensure
      # all the validations are called and the iteration does not stop as soon
      # as a validation fails
      #
      def validate_nested_forms
        # If no nested forms are present in the class, just return true since
        # no validation should be tested
        return true unless nested_forms

        # Run all validations on all nested forms and ensure they're all valid
        nested_forms.map do |name, form|
          if object.respond_to?(name) && (resource = object.send(name))
            Array.wrap(resource).map { |m| form.new(m, step).validate }.all?
          else
            # Nested validations shouldn't be run on undefined relations
            true
          end
        end.all?
      end
    end
  end
end
