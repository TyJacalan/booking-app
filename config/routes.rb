Rails.application.routes.draw do
  devise_for :users, controllers: {
    # omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    get :freelancer_registration, to: 'users/registrations#new_freelancer', as: :new_freelancer
    post :freelancer_registration, to: 'users/registrations#create_freelancer', as: :create_freelancer
  end

  root 'services#index'

  resources :notifications, only: [:index, :create, :update]
  resources :roles

  resources :services do
    resources :reviews, only: [:index]
    resources :overall_service_ratings, only: [:show]
    resources :appointments, except: [:show, :edit], shallow: true do
      resources :reviews, only: [:new, :index, :create], shallow: true do
        resources :comments, only: [:index, :create], shallow: true
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
