FactoryBot.define do
  factory :service do
    association :company
    name {  Faker::Name.name }
    price { 20 }
    time { 20 }
  end
end