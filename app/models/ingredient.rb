class Ingredient < ActiveRecord::Base
  include ActiveModel::Validations

  belongs_to :recipe
  belongs_to :measurement_unit, optional: true

  validates_with QuantityFormatValidator

  def amount
    Amount.new(quantity, measurement_unit)
  end

  def format_for_display
    "#{amount} #{name.downcase}"
  end
end
