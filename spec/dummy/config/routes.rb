Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  mount_stall '/'

  resources :books
end
