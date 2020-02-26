Rails.application.routes.draw do
  resources :ingredients, only: [ :new, :create ]
end
