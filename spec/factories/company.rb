FactoryBot.define do
  factory :company do
    chairs { 5 }
    gstin { "27AAFCK8380D1ZE"}
    name {  Faker::Company.name }
    address { Faker::Address.full_address }
    pan { "BQNPR#{Faker::Number.number(digits: 4)}D" }
  end
end
    