class Company < ApplicationRecord
  has_many :services
  has_many :appointments

  belongs_to :start_time, class_name: :TimeSlot
  belongs_to :end_time, class_name: :TimeSlot

  validates :name, presence: true, uniqueness: true
  validates :pan, presence: false, format: { with: /\A[A-Z]{5}[0-9]{4}[A-Z]{1}\z/i }
  validates :gstin, presence: false, format: { with: /\A \d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}[Z]{1}[A-Z\d]{1}\z/i }

end
