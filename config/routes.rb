Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts do
    member do
      patch :publish
    end
    resources :comments, only: [ :create, :destroy ]
  end

  root "posts#index"
end
