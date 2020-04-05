Rails.application.routes.draw do
  resources :ingredients, only: [ :new, :create ]
  resources :ingredients_search_results, only: [ :index ]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  resources :users, only: [ :new, :create, :show ]
end
