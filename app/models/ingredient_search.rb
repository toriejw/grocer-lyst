class IngredientSearch

  DEFAULT_LIMIT = 5

  def initialize(query)
    @query = query&.gsub(/[^\w ]/, "")
  end

  def results(limit = nil)
    return [] if @query.nil? || @query.empty?
    Ingredient.where("name ILIKE ?", "#{@query}%").limit(limit || DEFAULT_LIMIT)
  end

end
