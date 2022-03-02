FactoryBot.define do
  factory :time_slot do
    from_time { "08:30" }
    to_time   { "08:45" }
  end
end