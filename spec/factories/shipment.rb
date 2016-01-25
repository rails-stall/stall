FactoryGirl.define do
  factory :shipment, class: Stall::Shipment do
    cart { build(:cart) }
  end
end
