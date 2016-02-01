module Stall
  module Checkout
    class Wizard
      class StepUndefinedError < StandardError; end

      attr_reader :cart

      class_attribute :_steps

      def self.steps(*identifiers)
        if identifiers.length > 0
          self._steps = identifiers
        else
          _steps
        end
      end

      def initialize(cart)
        @cart = cart
      end

      def initialize_current_step(&block)
        step = current_step.new(cart)

        # This block allows us to let inject controller-bound dependencies
        # into the step just after it's initialized
        block.call(step) if block

        if step.skip?
          validate_current_step!
          initialize_current_step(&block)
        else
          step
        end
      end

      def current_step
        Stall::Checkout::Step.for(current_step_name)
      end

      def current_step_name
        if step?(cart.state)
          cart.state
        else
          raise StepUndefinedError,
            "The current carte state #{ cart.state } does not exist " +
            "for the current #{ self.class.name } wizard, which has the " +
            "following steps : #{ steps.join(', ') }."
        end
      end

      def next_step_name
        step_name_for(step_index + 1) if step_index && step_index < steps_count
      end

      def complete?
        step_index && step_index >= steps_count - 1
      end

      def steps_count
        @steps_count ||= steps.length
      end

      def validate_current_step!
        cart.state = next_step_name
        cart.save!
      end

      def self.route_key
        name.gsub(/CheckoutWizard/, '').underscore.gsub('_', ' ').parameterize
      end

      def self.from_route_key(key)
        Stall::Utils.try_load_constant(
          [key.underscore.camelize, 'CheckoutWizard'].join
        )
      end

      private

      def steps
        @steps ||= self.class.steps
      end

      def step_name_for(index)
        steps[index]
      end

      def step_index
        steps.index(cart.state)
      end

      def step?(state)
        steps.include?(state)
      end
    end
  end
end
