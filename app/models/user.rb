class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  default_scope -> { where(is_active: true) }


end
