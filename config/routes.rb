Rails.application.routes.draw do
  get "home/index"
  root to: "home#index"

  resources :ingredients, only: [ :new, :create ]
  resources :ingredients_search_results, only: [ :index ]

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users, only: [ :new, :create, :show ], param: :user_id
  resources :users do
    resources :recipes, only: [ :new, :create, :show ]
  end
end
