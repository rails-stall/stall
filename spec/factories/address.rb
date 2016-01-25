FactoryGirl.define do
  factory :address, class: Stall::Address do
    civility 'M'
    first_name 'Jean'
    last_name 'Val'
    address '1 rue de la rue'
    city 'Paris'
    zip '75001'
    country 'FR'
  end
end
