FactoryGirl.define do
  factory :address do
    civility :m
    first_name 'Jean'
    last_name 'Val'
    address '1 rue de la rue'
    city 'Paris'
    zip '75001'
    country 'FR'

    factory :billing_address, class: BillingAddress
    factory :shipping_address, class: ShippingAddress
  end
end
