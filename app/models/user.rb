class User < ApplicationRecord
  has_many :recipes
  has_one :grocery_list

  validates :name,
    presence: true,
    allow_blank: false

  validates :email,
    presence: true,
    allow_blank: false,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    uniqueness: { message: "An account with that email has already been created." }

  has_secure_password

end
