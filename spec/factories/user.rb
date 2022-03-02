FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password {Faker::Internet.password}
    phone_number { Faker::Number.number(digits: 10) }
    role { User.roles[:admin] }
    name {  Faker::Name.name }
  end
end
