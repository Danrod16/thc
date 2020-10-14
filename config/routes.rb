Rails.application.routes.draw do

  devise_for :users
  get 'monday', to: 'day#monday', as: "monday"
  get 'tuesday', to: 'day#tuesday', as: "tuesday"
  get 'wednesday', to: 'day#wednesday', as: "wednesday"
  get 'thursday', to: 'day#thursday', as: "thursday"
  get 'friday', to: 'day#friday', as: "friday"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root :to => 'passthrough#index'
  resources :orders
  resources :riders, only: [:index, :show]
  resources :deliveries, only: [:index, :show, :edit, :new, :create, :update, :destroy]
  get 'riders-deliveries', to: 'riders#deliveries', as: "riders_deliveries"
  get '/today', to: 'orders#today'
end
