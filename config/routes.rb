Rails.application.routes.draw do
  get 'brick_shipments/index'

  get 'brick_shipments/new'

  get 'brick_shipments/create'

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

  post 'clay_shipments/rearrange' => 'clay_shipments#rearrange'
  get 'clay_shipments/finish' => 'clay_shipments#finish'

  resources :users
  resources :clay_shipments, only: [:new, :create, :index, :edit, :show]
  resources :brick_shipments, only: [:new, :create, :index, :edit]
  resources :account_activations, only: [:edit]
end
