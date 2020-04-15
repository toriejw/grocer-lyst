class User < ApplicationRecord
  has_many :recipes

  validates :username,
    presence: true,
    allow_blank: false,
    uniqueness: { message: "\"%{value}\" is already taken. Please choose another!" }

  has_secure_password

end
