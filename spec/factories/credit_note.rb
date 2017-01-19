FactoryGirl.define do
  factory :credit_note do
    customer { build(:customer) }
    amount 0
  end
end
