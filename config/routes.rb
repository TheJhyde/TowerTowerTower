Rails.application.routes.draw do
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'admin' => 'static_pages#admin'
  get 'report' => 'static_pages#report'
  post 'submit' => 'static_pages#submit'
  get 'news_items' => 'static_pages#news_items'
  get 'actions' => 'static_pages#actions'
  get 'strength' => 'static_pages#strength'
  get 'gravity' => 'static_pages#gravity'
  get 'level' => 'static_pages#level'


  get 'login' => 'sessions#new'
  get 'session' => 'sessions#index'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'signup' => 'users#new'
  resources :users

  resources :account_activations, only: [:edit]

  get 'build_orders/finished' => 'build_orders#finished'
  get 'build_orders/get_orders/:id' => 'build_orders#get_orders'
  resources :build_orders, only: [:new, :create, :index, :show]

  resources :tower, only: [:index, :show]
  get 'tower/history/:id' => 'tower#history'
  resources :password_resets, only: [:new, :create, :edit, :update]
end
