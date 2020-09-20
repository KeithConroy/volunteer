Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'

  resources :shifts do
    member do
      post :sign_up
    end

    collection do
      get :search_index
    end
  end

  resources :shift_types
  resources :roles
  resources :users do
    collection do
      post :assign_role
      post :remove_role
    end
  end
  resources :organizations

end
