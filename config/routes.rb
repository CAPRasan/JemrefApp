Rails.application.routes.draw do
  get "records/new", to: "records#new"
  post "records/create_book", to: "records#create_book"
  post "records/create_paper", to: "records#create_paper"
  post "records/create_compilation", to: "records#create_compilation"
  get "records/index", to: "records#index"
  get "records/:id/edit", to: "records#edit", as: :edit_record
  delete "records/:id/destroy", to: "records#destroy", as: :destroy_record
  patch "records/:id/update", to: "records#update", as: :update_record

  post "users/create", to: "users#create"
  post "login", to: "users#login"
  get "login", to: "users#login_form"
  get "logout", to: "users#logout"
  get "users/index", to: "users#index"
  get "signup", to: "users#new"

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
