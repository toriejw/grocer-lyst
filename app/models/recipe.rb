class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, inverse_of: :recipe
  accepts_nested_attributes_for :ingredients, reject_if: :all_blank, allow_destroy: true

  scope :alphabetized, -> { sort_by { |recipe| recipe.name} }

  validates :name, presence: true
end
