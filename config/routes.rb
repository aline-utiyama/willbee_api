require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      get "/users/settings", to: "users#show"
      resources :users, only: [ :create, :update ]
      resources :goals
      resources :goal_plans

      resources :goal_progresses, only: [] do
        patch :complete_today, on: :collection
        patch :complete_progress_through_notifications
      end

      resources :notifications, only: [] do
        patch :mark_as_read
      end
    end
  end

  if Rails.env.development? || Rails.env.production?
    mount Sidekiq::Web => "/sidekiq"
    mount ActionCable.server => "/cable"
  end
end
