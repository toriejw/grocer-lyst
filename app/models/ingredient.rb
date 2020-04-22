class Ingredient < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :recipe
  validates_with QuantityFormatValidator
end
