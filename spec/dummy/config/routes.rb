Rails.application.routes.draw do
  root 'home#index'

  resources :books

  mount_stall '/'
end
