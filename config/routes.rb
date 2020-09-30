Rails.application.routes.draw do
  get 'lunes', to: 'day#monday'
  get 'martes', to: 'day#tuesday'
  get 'miercoles', to: 'day#wednesday'
  get 'jueves', to: 'day#thursday'
  get 'viernes', to: 'day#friday'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'pages#home'
  resources :orders
  get '/today', to: 'orders#today'
end
