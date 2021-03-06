Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    authenticated :user do
      root :to => 'home#landing', as: :authenticated_root, via: :get
    end
    unauthenticated :user do
      root :to => 'home#index', as: :unauthenticated_root
    end
  end

  resources :shift_types
  resources :schedules
  resources :addresses

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

  resources :roles do
    collection do
      post :assign_user
      post :remove_user
    end
  end

  resources :users do
    member do
      get :profile
    end
  end

  resources :organizations do
    member do
      post :request_access
      post :grant_access
      post :deny_access
      post :ban_user
      post :revoke_admin
      post :make_admin
      get :manage
    end

    collection do
      get :search
    end
  end

  get '/404', to: "errors#not_found"
  get '/422', to: "errors#unacceptable"
  get '/500', to: "errors#internal_error"
end
