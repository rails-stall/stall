class FakeCheckoutWizard < Stall::Checkout::Wizard
  steps :fake, :final
end

class FakeCheckoutStep < Stall::Checkout::Step
  def process
    false
  end
end

class FinalCheckoutStep < Stall::Checkout::Step
end

class FakeCart < Stall::Cart
  def wizard
    FakeCheckoutWizard
  end
end


module CheckoutSpecHelper
  def create_cart(options = {})
    allow(controller).to receive(:cart_class).and_return(FakeCart)

    controller.current_cart.reload.tap do |cart|
      cart.line_items << build(:line_item) unless options[:line_items]
      cart.assign_attributes(options)
      cart.save!
    end
  end
end
