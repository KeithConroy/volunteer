Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'

  resources :shifts do
    member do
      post :sign_up
    end
  end
  resources :shift_types
  resources :users
  resources :organizations


end
