class User < ApplicationRecord

  validates :username,
    presence: true,
    allow_blank: false,
    uniqueness: { message: "\"%{value}\" is already taken. Please choose another!" }

  has_secure_password

end
