Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get :freelancer_registration, to: 'users/registrations#new_freelancer', as: :new_freelancer
    post :freelancer_registration, to: 'users/registrations#create_freelancer', as: :create_freelancer
    get :freelancer_update, to: 'users/registrations#edit_freelancer', as: :edit_freelancer
    patch :freelancer_update, to: 'users/registrations#update_freelancer', as: :update_freelancer
  end

  root 'services#index'

  resources :alerts, only: %i[index]
  resources :appointments, except: %i[show]
  resources :batch_update_notifications, only: [:update]
  resources :calendars, except: %i[new show edit update]
  resources :notifications, only: %i[index update]
  resources :payments
  resources :roles
  resources :reviews
  resources :locations, only: [:index]
  resources :categories, only: [:index]
  resources :search, only: [:index]
  resources :search_location, only: [:create]

  resources :users do
    member do
      get :reviews, to: 'users#reviews', only: [:show]
      get :services, to: 'users#services', only: [:show]
    end
    resources :roles, module: :users, only: [:update]
    resources :blocked_dates, module: :users, only: [:index]
  end

  resources :services do
    get 'reviews/recent_10', to: 'reviews_index#recent_10_reviews', as: 'recent_10_reviews'
    get 'reviews/recent', to: 'reviews_index#recent_reviews', as: 'recent_reviews'
    get 'reviews/most_rated', to: 'reviews_index#most_rated_reviews', as: 'most_rated_reviews'
    get 'reviews/least_rated', to: 'reviews_index#least_rated_reviews', as: 'least_rated_reviews'
    get 'overall_service_ratings', to: 'overall_service_ratings#show', as: 'overall_service_ratings'
    get 'overall_service_ratings/show_modal', to: 'overall_service_ratings#show_modal', as: 'overall_service_ratings_modal'

    resources :appointments, except: %i[show edit create update destroy index] do
      resources :reviews, only: %i[new show index create], shallow: true do
        resources :comments, only: %i[index create], shallow: true
      end
    end
  end

  get 'up' => 'rails/health#show', as: :rails_health_check

  # Error routes
  get '/404', to: 'errors#not_found', via: :all
  get '/403', to: 'errors#forbidden', via: :all
  get '/422', to: 'errors#unprocessable', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all
end
