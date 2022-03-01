class TimeSlot < ApplicationRecord

  validates :from_time, :to_time, presence: true, uniqueness: true
  validates :from_time, uniqueness: { scope: [:to_time] }

end
