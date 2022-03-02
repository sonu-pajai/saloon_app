class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
          :registerable,
        jwt_revocation_strategy: JwtDenylist


  default_scope -> { where(is_active: true) }

  has_many :appointments, dependent: :destroy

  validates :name, :phone_number, presence: true
  validates :phone_number, :email, uniqueness: true

end
