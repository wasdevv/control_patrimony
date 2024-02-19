Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  get '/employee/new', to: 'employees#new', as: :new_employee
  
  resources :employees, only: [:new, :create, :edit, :show]

  resources :logs do
    member do
    end
  end

  get '/contact', to: 'pages#contact', as: :contact
  
  root 'pages#home'
end
