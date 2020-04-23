class Ingredient < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :recipe
  belongs_to :measurement_unit, optional: true

  validates_with QuantityFormatValidator
end
