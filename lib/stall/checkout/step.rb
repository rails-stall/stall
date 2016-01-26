module Stall
  module Checkout
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
        params.require(:cart).permit!
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
    end
  end
end
