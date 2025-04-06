Rails.application.routes.draw do
  devise_for :users
  root 'projects#index'
  resources :projects do
    resources :comments, only: [:create, :destroy]
  end
end
