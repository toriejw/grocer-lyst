class QuantityFormatValidator < ActiveModel::Validator
  def validate(record)
    if invalid_quantity_format?(record.quantity)
      record.errors.add(:quantity, "format is invalid")
    end
  end

  def invalid_quantity_format?(quantity)
    !valid_quantity_format?(quantity)
  end

  def valid_quantity_format?(quantity)
    return false if contains_letters?(quantity)

    valid_whole_number_format?(quantity) ||
    valid_fraction_format?(quantity) ||
    valid_decimal_format?(quantity)
  end

  def contains_letters?(quantity)
    quantity.match?(/[a-zA-Z]+/)
  end

  def valid_whole_number_format?(quantity)
    quantity.match?(/^\d+$/)
  end

  def valid_fraction_format?(quantity)
    quantity.match?(/^(\d+ )?\d+\/\d+$/)
  end

  def valid_decimal_format?(quantity)
    quantity.match?(/^\d*\.\d+$/)
  end
end
