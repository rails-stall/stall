FactoryGirl.define do
  factory :shipping_method, class: 'Stall::ShippingMethod' do
    name 'Carrier'
    identifier 'carrier'
  end
end
