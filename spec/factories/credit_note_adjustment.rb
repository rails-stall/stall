FactoryGirl.define do
  factory :credit_note_adjustment do
    name 'Credit note'
    price -50

    cart { build(:cart) }
  end
end
