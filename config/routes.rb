Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :shifts
  resources :shift_types
  resources :users
  resources :organizations
end
