Rails.application.routes.draw do
  resources :ingredients, only: [ :new, :create ]
  resources :ingredients_search_results, only: [ :index ]
end
