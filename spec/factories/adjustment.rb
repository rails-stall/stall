FactoryGirl.define do
  factory :adjustment do
    name 'Discount'
    price 12

    cart { build(:cart) }
  end
end
