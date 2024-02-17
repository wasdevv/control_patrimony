Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  get '/employee/new', to: 'employees#new', as: :new_employee
  
  resources :employees

  resources :logs do
    member do
    end
  end
  
  root 'pages#home'
end
