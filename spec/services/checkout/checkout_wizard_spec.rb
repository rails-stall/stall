require 'rails_helper'

class FakeDefaultCheckoutWizard < Stall::Checkout::Wizard
  steps :step1, :step2, :step3
end

class Step1CheckoutStep < Stall::Checkout::Step
  def skip?
    respond_to?(:skip) && skip
  end
end

class Step2CheckoutStep < Stall::Checkout::Step
end

RSpec.describe Stall::Checkout::Wizard do
  describe '.steps' do
    it 'allows subclasses to define the checkout wizard steps when passed arguments' do
      expect(FakeDefaultCheckoutWizard._steps).to eq([:step1, :step2, :step3])
    end

    it 'returns the current steps when no arguments are passed' do
      expect(FakeDefaultCheckoutWizard.steps).to eq([:step1, :step2, :step3])
    end
  end

  describe '.route_key' do
    it 'returns a clean route key for URL serialization' do
      expect(FakeDefaultCheckoutWizard.route_key).to eq('fake-default')
    end
  end

  describe '.from_route_key' do
    it 'returns a wizard from a given route key' do
      wizard = Stall::Checkout::Wizard.from_route_key('fake-default')
      expect(wizard).to eq(FakeDefaultCheckoutWizard)
    end
  end

  describe '#initialize_current_step' do
    it 'returns a step instance of the current step type' do
      cart = build(:cart, state: :step1)
      wizard = FakeDefaultCheckoutWizard.new(cart)
      step = wizard.initialize_current_step
      expect(step).to be_a(Step1CheckoutStep)
    end

    it 'returns the next step if the current one should be skipped' do
      cart = build(:cart, state: :step1)
      wizard = FakeDefaultCheckoutWizard.new(cart)
      step = wizard.initialize_current_step do |step|
        step.inject(:skip, true)
      end
      expect(step).to be_a(Step2CheckoutStep)
    end

    it 'allows dependency injection on instanciation with a config block' do
      cart = build(:cart, state: :step1)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      step = wizard.initialize_current_step do |step|
        step.inject(:foo, 'bar')
      end

      expect(step.foo).to eq('bar')
    end
  end

  describe '#current_step' do
    it 'returns the current step class' do
      cart = build(:cart, state: :step1)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.current_step).to eq(Step1CheckoutStep)
    end
  end

  describe '#current_step_name' do
    it 'returns the current checkout wizard step depending on the cart state' do
      cart = build(:cart, state: :step3)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.current_step_name).to eq(:step3)
    end

    it 'raises if the state is out of range for the wizard' do
      cart = build(:cart, state: :undefined)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect { wizard.current_step_name }.to raise_error(Stall::Checkout::Wizard::StepUndefinedError)
    end
  end

  describe '#next_step' do
    it 'returns the next step for the current cart' do
      cart = build(:cart, state: :step2)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.next_step_name).to eq(:step3)
    end

    it 'returns nil if there is not next step' do
      cart = build(:cart, state: :step3)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.next_step_name).to eq(nil)
    end
  end

  describe '#complete?' do
    it 'returns true if there is no next step' do
      cart = build(:cart, state: :step3)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.complete?).to eq(true)
    end

    it 'returns false if there is a next step' do
      cart = build(:cart, state: :step2)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.complete?).to eq(false)
    end
  end

  describe '#steps_count' do
    it 'returns the steps count' do
      cart = build(:cart)
      wizard = FakeDefaultCheckoutWizard.new(cart)

      expect(wizard.steps_count).to eq(3)
    end
  end

  describe '#validate_current_step!' do
    it 'sets the cart state to the next step' do
      cart = build(:cart, state: :step1)
      wizard = FakeDefaultCheckoutWizard.new(cart)
      wizard.validate_current_step!

      expect(cart.reload.state).to eq(:step2)
    end
  end
end
