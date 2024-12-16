Rails.application.routes.draw do
  # Devise routes for admins
  devise_for :admins, controllers: {
    sessions: 'admin/sessions',
    registrations: 'admin/registrations'
  }, path: 'admins', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  # Devise routes for users
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }, path: 'users', path_names: {
    sign_in: 'sign_in',
    sign_out: 'sign_out',
    sign_up: 'sign_up'
  }

  # Admin namespace routes
  namespace :admin do
    root 'dashboard#index' # Admin dashboard root route
    resources :users, only: [:index, :show, :destroy] do
      member do
        get 'add_money'        # Custom route for adding money
        post 'update_balance'  # To handle the actual update
      end
    end
  end

  # API namespace routes
  namespace :api do
    namespace :v1 do
      # Custom routes for sessions and users
      get 'user_data', to: 'users#user_data'
      get 'locations/towns', to: 'locations#towns'

      devise_scope :user do
        # Route for sign-in handled by the sessions controller
        post 'sign_in', to: 'sessions#create'
        # Route for sign-out handled by the sessions controller
        delete 'sign_out', to: 'sessions#destroy'
        # Route for sign-up handled by the registrations controller
        post 'sign_up', to: 'registrations#create'
        post 'password/forgot', to: 'passwords#forgot'
        post 'password/reset', to: 'passwords#reset'
      end

      resources :payments, only: [:index, :create]
      # Only define necessary RESTful routes for users
      resources :users, only: [:index, :create, :update, :destroy]
    end
  end

  # Exchange rates API
  namespace :api do
    namespace :v1 do
      get 'exchange_rates/latest', to: 'exchange_rates#latest'
    end
  end

  # Budgets API
  # namespace :api do
  #   namespace :v1 do
  #     resources :budgets, only: [:show] do
  #       member do
  #         get 'progress', to: 'budgets#show_progress'
  #       end
  #     end
  #   end
  # end

  # Other API route
  namespace :api do
    get 'check-username', to: 'users#check_username'
  end

  # Define other routes
  get '/member-data', to: 'members#show'
  root 'home#index' # Root route for the application
  get '/dashboard', to: 'dashboard#index', as: 'user_dashboard'
end
