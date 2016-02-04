FactoryGirl.define do
  factory :payment do
    cart { build(:cart) }
    payment_method { build(:payment_method) }
  end
end
