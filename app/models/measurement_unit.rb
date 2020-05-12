class MeasurementUnit < ApplicationRecord
  validates :name,
    inclusion: { in: MeasurementUnitConverter::CONVERSIONS.keys.map(&:to_s) }
end
