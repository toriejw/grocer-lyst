class GroceryListItem < ApplicationRecord
  belongs_to :grocery_list
  belongs_to :measurement_unit, optional: true

  def add_amount_from(additional_item)
    additional_amount = Amount.new(additional_item.quantity, additional_item.measurement_unit)
    new_amount = amount + additional_amount

    self.name = name.pluralize if (quantity <= 1 && new_amount.quantity > 1)
    self.quantity = new_amount.to_f
    self.measurement_unit = new_amount.measurement_unit
    self.save!
  end

  def amount
    Amount.new(quantity, measurement_unit)
  end
end
