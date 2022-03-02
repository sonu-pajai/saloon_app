class Service < ApplicationRecord

  has_many :appointments, dependent: :destroy

  belongs_to :company

  validates :name, :time, :price, presence: true
  validates :name, uniqueness: true

end
