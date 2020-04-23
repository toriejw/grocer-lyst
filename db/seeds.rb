# Measurement units
measurement_unit_types = %w(cup)

measurement_unit_types.each do |unit_type|
  MeasurementUnit.find_or_create_by(name: unit_type)
end
