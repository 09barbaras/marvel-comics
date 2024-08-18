Rails.application.routes.draw do
  root 'comics#index'

  devise_for :users

  resources :comics, only: [:index] do
    member do
      post :favorite, to: 'comics#toggle_favorite'
    end
  end
end
