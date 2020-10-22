Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :users do
    # get '/users/sign_out' => 'devise/sessions#destroy'
    # get 'users/:id' => 'users#show'
  end

  devise_scope :user do
    authenticated :user do
      root :to => 'organizations#index', as: :authenticated_root, via: :get
    end
    unauthenticated :user do
      root :to => 'home#index', as: :unauthenticated_root
    end
    # post '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :shifts do
    member do
      post :sign_up
      post :user_cancel
      post :admin_cancel
    end

    collection do
      get :search
    end
  end

  resources :shift_types
  resources :schedules
  resources :roles
  resources :users do
    member do
      get :my_organizations
      get :my_shifts
      get :profile
      get :change_tab
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
      get :manage
      get :change_tab
    end

    collection do
      get :search
    end
  end

end
