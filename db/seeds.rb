# Measurement units
measurement_unit_types = %w(
  cup
  teaspoon
  tablespoon
)

measurement_unit_types.each do |unit_type|
  MeasurementUnit.find_or_create_by(name: unit_type)
end
