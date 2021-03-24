Rails.application.routes.draw do

  get 'delivery_categories/new'
  get 'delivery_categories/index'
  get 'delivery_categories/show'
  get 'delivery_categories/create'
  get 'delivery_categories/update'
  get 'delivery_categories/destroy'
  devise_for :users
  get 'monday', to: 'days#monday', as: "monday"
  get 'tuesday', to: 'days#tuesday', as: "tuesday"
  get 'wednesday', to: 'days#wednesday', as: "wednesday"
  get 'thursday', to: 'days#thursday', as: "thursday"
  get 'friday', to: 'days#friday', as: "friday"
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root :to => 'passthrough#index'
  resources :orders
  resources :riders, only: [:index, :show]
  resources :delivery_categories do
    post '/reorganize', to: "delivery_categories#reorganize"
    resources :deliveries
  end
  resources :stickers
  get 'riders-deliveries', to: 'riders#deliveries', as: "riders_deliveries"
  get '/today', to: 'orders#today'
end
