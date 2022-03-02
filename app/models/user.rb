class User < ApplicationRecord

  enum role: [:admin, :customer, :sadmin ]

  devise :database_authenticatable,
         :jwt_authenticatable,
          :registerable,
        jwt_revocation_strategy: JwtDenylist

  default_scope -> { where(is_active: true) }

  has_many :appointments, dependent: :destroy

  validates :name, :phone_number, :role, presence: true
  validates :phone_number, :email, uniqueness: true

  User.roles.each do |role_name|
    define_method("#{role_name}?") do
      role.downcase == role_name.to_s
    end
  end

end
