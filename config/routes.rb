Rails.application.routes.draw do
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'admin' => 'static_pages#admin'
  get 'report' => 'static_pages#report'
  post 'submit' => 'static_pages#submit'
  get 'news_items' => 'static_pages#news_items'

  get 'signup' => 'users#new'

  get 'login' => 'sessions#new'
  get 'session' => 'sessions#index'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :account_activations, only: [:edit]
  resources :build_orders, only: [:new, :create, :index]
  get 'build_orders/finished' => 'build_orders#finished'
  resources :tower, only: [:index]
  resources :tower_pics, only: [:show, :index]
  resources :password_resets, only: [:new, :create, :edit, :update]
end
