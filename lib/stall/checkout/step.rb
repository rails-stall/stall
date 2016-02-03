module Stall
  module Checkout
    class StepNotFoundError < StandardError; end

    class Step
      attr_reader :cart

      def initialize(cart)
        @cart = cart
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
        save
      end

      def cart_params
        @cart_params ||= params.require(:cart).permit!
      end

      def skip?
        false
      end

      def is?(key)
        identifier == key
      end

      def identifier
        @identifier ||= begin
          class_name = self.class.name.demodulize
          class_name.gsub(/CheckoutStep$/, '').underscore.to_sym
        end
      end

      # Abstracts the simple case of assigning the submitted parameters to the
      # cart object, running the step validations and saving the cart
      def save
        cart.assign_attributes(cart_params)
        cart.save if valid?
      end

      # Handles conversion from an identifier to a checkout step class, allowing
      # us to specify a list of symbols in our wizard's .step macro
      #
      def self.for(identifier)
        name = identifier.to_s.camelize
        step_name = [name, 'CheckoutStep'].join
        # Try loading step from app
        step = Stall::Utils.try_load_constant(step_name)
        # Try loading step from stall core or lib if not found in app
        step = Stall::Utils.try_load_constant(
          ['Stall', 'Checkout', step_name.demodulize].join('::')
        ) unless step

        unless step
          raise StepNotFoundError,
            "No checkout step was found for #{ identifier }. You can generate " +
            "it with `rails g stall:checkout:step #{ identifier }`"
        end

        step
      end

      def self.validations(&block)
        return @validations unless block
        @validations = Stall::Checkout::StepForm.build(&block)
      end

      def valid?
        return true unless (validations = self.class.validations)
        validations.new(cart, self).validate
      end

      def _validation_method_missing(method, *args, &block)
        send(method, *args, &block) if respond_to?(method)
      end
    end
  end
end
