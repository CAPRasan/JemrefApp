Rails.application.routes.draw do
  post "records/create" => "records#create"
  get "records/index" => "records#index"
  get "records/:id/edit" => "records#edit"
  post "records/:id/update" => "records#update"

  post "users/create" => "users#create"
  post "login" => "users#login"
  get "login" => "users#login_form"
  get "logout" => "users#logout"
  get "users/index" => "users#index"
  get "users/signup" => "users#new"

  get "/" => "home#top"







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
