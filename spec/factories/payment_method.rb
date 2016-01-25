FactoryGirl.define do
  factory :payment_method, class: Stall::PaymentMethod do
    name 'Credit card'
    identifier 'credit-card'
  end
end
