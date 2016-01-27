module Stall
  module Checkout
    class StepForm
      include ActiveModel::Validations

      class_attribute :nested_forms

      attr_reader :target, :step

      def initialize(target, step)
        @target = target
        @step = step
      end

      def validate
        super && validate_nested_forms
      end

      def validate_nested_forms
        self.class.nested_forms.each do |name, form|
          if respond_to?(name) && (model = target.send(name))
            if model.respond_to(:each)
              model.all? { |m| form.new(m, step).validate }
            else
              form.new(model, step).validate
            end
          else
            true
          end
        end
      end

      def self.nested(type, &block)
        self.nested_forms ||= {}
        nested_forms[type] = Class.new(StepForm, &block)
      end

      def method_missing(method, *args, &block)
        step._validation_method_missing(method, *args, &block) || super
      end
    end

    class StepNotFoundError < StandardError; end

    class Step
      attr_reader :cart, :params

      def initialize(cart, params)
        @cart = cart
        @params = params
      end

      # Allow injecting dependencies on step initialization and accessing
      # them as instance method in subclasses
      def inject(method, content)
        define_singleton_method(method, -> { content })
      end

      # Allows for preparing to the cart for the current step before rendering
      # the step's view
      #
      # Note : Meant to be overriden by subclasses
      #
      def prepare
      end

      def process
        cart.update_attributes(cart_params)
      end

      def cart_params
        @cart_params ||= params.require(:cart).permit!
      end

      def skip?
        false
      end

      # Handles conversion from an identifier to a checkout step class, allowing
      # us to specify a list of symbols in our wizard's .step macro
      #
      def self.for(identifier)
        name = identifier.to_s.camelize
        step_name = [name, 'CheckoutStep'].join

        step = Stall::Utils.try_load_constant(step_name) ||
          Stall::Utils.try_load_constant(['Stall', 'Checkout', step_name.demodulize].join('::'))

        return step if step

        raise StepNotFoundError,
          "No checkout step was found for #{ identifier }. You can generate " +
          "it with `rails g stall:checkout:step #{ identifier }`"
      end

      def self.validations(&block)
        if block
          @validations = Class.new(Stall::Checkout::StepForm, &block)
        else
          @validations
        end
      end

      def valid?
        if @validations
          @validations.new(self).validate
        else
          true
        end
      end

      def _validation_method_missing(method, *args, &block)
        send(method, *args, &block) if respond_to?(method)
      end
    end
  end
end
