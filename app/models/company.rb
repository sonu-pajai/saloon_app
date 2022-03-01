class Company < ApplicationRecord
  has_many :services
  has_many :appointments

  belongs_to :start_time, class_name: :TimeSlot
  belongs_to :end_time, class_name: :TimeSlot

  validates :name, presence: true, uniqueness: true

end
