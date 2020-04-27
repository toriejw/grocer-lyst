class Amount
  include Comparable

  def initialize(quantity, measurement_unit)
    @quantity = quantity
    @measurement_unit = measurement_unit
  end

  def rationalized_quantity
    @quantity.split.reduce(Rational(0)) { |sum, n| sum += Rational(n) }
  end

  def to_s
    if @measurement_unit
      "#{@quantity} #{unit_display}"
    else
      @quantity
    end
  end

  private

    def pluralize_unit?
      rationalized_quantity > 1
    end

    def unit_display
      if pluralize_unit?
        @measurement_unit.name.pluralize
      else
        @measurement_unit.name
      end
    end
end
