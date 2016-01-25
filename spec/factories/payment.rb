FactoryGirl.define do
  factory :payment, class: Stall::Payment do
    cart { build(:cart) }
    payment_method { build(:payment_method) }
  end
end
