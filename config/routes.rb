Rails.application.routes.draw do
  root 'static_pages#home'
  #get 'static_pages/about'
  get 'about' => 'static_pages#about'
  get 'admin' => 'static_pages#admin'
  get 'report' => 'static_pages#report'
  post 'submit' => 'static_pages#submit'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :account_activations, only: [:edit]
  resources :build_orders, only: [:new, :create]
  resources :tower, only: [:index]
  get 'build_orders/finished' => 'build_orders#finished'
end
