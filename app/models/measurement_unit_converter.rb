class MeasurementUnitConverter
  CONVERSIONS = {
    cup:        { tablespoon: [ "*", 16 ], teaspoon: [ "*", 48 ] },
    tablespoon: { cup: [ "/", 16 ], teaspoon: [ "*", 3 ] },
    teaspoon:   { cup: [ "/", 48 ], tablespoon: [ "/", 3 ] },
  }

  def self.can_convert_between?(unit_type1, unit_type2)
    (
      CONVERSIONS.keys&.include?(unit_type1&.to_sym) &&
      CONVERSIONS[unit_type1.to_sym].keys.include?(unit_type2&.to_sym)
    ) ||
    (
      CONVERSIONS.keys&.include?(unit_type2&.to_sym) &&
      CONVERSIONS[unit_type2.to_sym].keys.include?(unit_type1&.to_sym)
    )
  end

  def self.convert(from:, to:, quantity:)
    return nil unless can_convert_between?(from, to)

    conversion = CONVERSIONS[from.to_sym][to.to_sym]
    quantity.to_f.send(conversion[0], conversion[1])
  end

  def self.largest_unit_between(unit_type1, unit_type2)
    return nil unless can_convert_between?(unit_type1.to_sym, unit_type2.to_sym)
    if CONVERSIONS.keys&.include?(unit_type1&.to_sym)
      if CONVERSIONS[unit_type1.to_sym][unit_type2.to_sym][0] == "*"
        unit_type1
      else
        unit_type2
      end
    end
  end
end
