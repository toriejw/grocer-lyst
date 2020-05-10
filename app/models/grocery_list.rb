class GroceryList < ApplicationRecord
  belongs_to :user
  has_many :grocery_list_items

  def add_ingredients(ingredients)
    ingredients.each do |ingredient|
      matching_items_for_ingredient = matching_items_for(ingredient.name)
      if matching_items_for_ingredient.empty?
        create_item_from_ingredient(ingredient)
      else
        add_ingredient_quantity_to_item(matching_items_for_ingredient, ingredient)
      end
    end
  end

  def recipes
    return [] if recipe_ids.nil?
    user.recipes.find(recipe_ids)
  end

  private

    def add_ingredient_quantity_to_item(existing_items, ingredient)
      existing_item = existing_items.find do |item|
        Amount.can_convert_between?(item.amount, ingredient.amount)
      end

      if existing_item
        existing_item.add_amount_from(ingredient)
      else
        create_item_from_ingredient(ingredient)
      end
    end

    def create_item_from_ingredient(ingredient)
      grocery_list_items.create!(
        name: ingredient.name,
        quantity: ingredient.amount.rationalized_quantity.to_f,
        measurement_unit: ingredient.measurement_unit
      )
    end

    def matching_items_for(target_name)
      grocery_list_items.select do |item|
        item.name.downcase.singularize == target_name.downcase.singularize
      end
    end
end
