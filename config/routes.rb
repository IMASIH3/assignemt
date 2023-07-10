Rails.application.routes.draw do
  resources :service_types
  resources :parcels
  resources :addresses
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources  :userlist
  root to: 'search#index'
  get '/search', to: 'search#index'
  resources :csv_files, only: [:index, :show]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
