FactoryGirl.define do
  factory :shipment do
    shipping_method { build(:shipping_method) }
    cart { build(:cart) }
  end
end
