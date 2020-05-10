class Amount
  include Comparable

  attr_reader :quantity, :measurement_unit

  def self.can_convert_between?(amount1, amount2)
    amount1.can_convert_to?(amount2.measurement_unit)
  end

  def initialize(quantity, measurement_unit)
    @quantity = quantity
    @measurement_unit = measurement_unit
  end

  def can_convert_to?(measurement_unit)
    @measurement_unit == measurement_unit
  end

  def cannot_convert_to?(measurement_unit)
    !can_convert_to?(measurement_unit)
  end

  def rationalized_quantity
    if @quantity.is_a? String
      @quantity.split.reduce(Rational(0)) { |sum, n| sum += Rational(n) }
    else
      Rational(@quantity)
    end
  end

  def to_f
    rationalized_quantity.to_f
  end

  def to_s
    string_quantity = @quantity.is_a?(String) ? @quantity : "%g" % @quantity.ceil(2)
    if @measurement_unit
      "#{string_quantity} #{unit_display}"
    else
      string_quantity
    end
  end

  def +(other)
    if cannot_convert_to?(other.measurement_unit)
      raise_inconvertible_error(other.measurement_unit)
    end

    if @measurement_unit == other.measurement_unit
      combined_quantity = rationalized_quantity + other.rationalized_quantity
      Amount.new(combined_quantity, @measurement_unit)
    end
  end

  def <=>(other)
    return nil if other.class != self.class
    rationalized_quantity <=> other.rationalized_quantity
  end

  private

    def pluralize_unit?
      rationalized_quantity > 1
    end

    def raise_inconvertible_error(other_measurement_unit)
      error_msg = "Cannot convert between #{@measurement_unit&.name || 'nil'} " +
                  "and #{other_measurement_unit&.name || 'nil'}"
      raise(error_msg)
    end

    def unit_display
      if pluralize_unit?
        @measurement_unit.name.pluralize
      else
        @measurement_unit.name
      end
    end
end
