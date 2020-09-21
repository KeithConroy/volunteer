Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'home#index'

  resources :shifts do
    member do
      post :sign_up
      post :user_cancel
      post :admin_cancel
    end

    collection do
      get :search_index
    end
  end

  resources :shift_types
  resources :roles
  resources :users do
    member do
      get :my_organizations
      get :my_shifts
    end

    collection do
      post :assign_role
      post :remove_role
    end
  end
  resources :organizations do
    member do
      post :request_access
      post :grant_access
      post :deny_access
      post :ban_user
    end
  end

end
