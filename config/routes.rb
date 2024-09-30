Rails.application.routes.draw do
  get "sessions/new"
  resources :records, only: [ :new, :index, :edit ]
  post "records/create_book", to: "records#create_book"
  post "records/create_paper", to: "records#create_paper"
  post "records/create_compilation", to: "records#create_compilation"
  delete "records/:id/destroy", to: "records#destroy", as: :destroy_record
  patch "records/:id/update", to: "records#update", as: :update_record

  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users

  root to: "home#top"








  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
