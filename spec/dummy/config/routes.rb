Rails.application.routes.draw do
  resources :books

  mount_stall '/'
end
