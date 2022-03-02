FactoryBot.define do
  factory :appointment do
    association :company
    association :service
    date { Date.today }
    status { Appointment.statuses[:confirmed]}
  end
end
