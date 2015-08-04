Rails.application.routes.draw do
  root "courses#index"
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
    resource :uploads, only: [:create]
  end

  resources :users
  resources :courses, only: [:index, :show]
  resources :user_subjects, only: [:show, :update]
end
