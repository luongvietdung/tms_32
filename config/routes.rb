Rails.application.routes.draw do
  root "static_pages#home"
  get "about" => "static_pages#about"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  namespace :supervisor do
    root "courses#index"
    resources :courses do
      resource :course_subject, only: [:show]
      resource :course_user, only: [:show]
    end
    resources :subjects
    resources :users
  end
  resources :users
  resources :courses, only: [:index, :show]
end
