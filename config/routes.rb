Rails.application.routes.draw do
  root "comics#index"

  resources :comics
end
