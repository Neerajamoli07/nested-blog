Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  get "signup", to: "registrations#new", as: :signup
  post "signup", to: "registrations#create"

  get "search", to: "search#index", as: :search

  resources :notifications, only: %i[ index ] do
    member do
      patch :mark_read
    end
    collection do
      patch :mark_all_read
    end
  end

  post "/likes/:likeable_type/:likeable_id", to: "likes#create", as: :like
  delete "/likes/:likeable_type/:likeable_id", to: "likes#destroy", as: :unlike

  namespace :admin do
    root to: "dashboard#show"
    resources :users, only: %i[ index update destroy ]
    resources :posts, only: %i[ index destroy ]
  end

  resources :posts do
    member do
      patch :publish
    end
    resources :comments, only: %i[ create destroy ]
  end

  root "posts#index"
end
