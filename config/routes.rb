Rails.application.routes.draw do
  get 'users/new'

  root 'static_pages#home'
  #get 'static_pages/about'
  get 'about' => 'static_pages#about'
  get 'signup' => 'users#new'
end
