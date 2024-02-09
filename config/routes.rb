Rails.application.routes.draw do
  get 'log/index'
  get 'employee/index'
  get 'employee/new'
  get 'employee/edit'
  get 'employee/show'
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check
  
  
  
  root 'pages#home'
end
