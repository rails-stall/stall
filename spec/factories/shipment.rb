FactoryGirl.define do
  factory :shipment, class: Stall::Shipment do
    shipping_method { build(:shipping_method) }
    cart { build(:cart) }
  end
end
