Rails.application.routes.draw do
  root 'static_pages#home'
  #get 'static_pages/about'
  get 'about' => 'static_pages#about'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users
  resources :clay_shipments, only: [:new, :create, :index, :edit]
end
