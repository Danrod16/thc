Rails.application.routes.draw do
  root to: 'pages#home'
  get '/raw_data', to: 'orders#raw_data'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
