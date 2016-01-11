Rails.application.routes.draw do
  get 'clay_shipments/new'

  get 'clay_shipments/index'

  root 'static_pages#home'
  #get 'static_pages/about'
  get 'about' => 'static_pages#about'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users
end
