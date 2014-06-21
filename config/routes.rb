Rails.application.routes.draw do
  root to: 'festivals#index'

  namespace :api do
    resources :festivals, only: [:index, :show]
    resources :schedules, only: [:create, :show, :update]
  end

  namespace :beta do
    post :signup
  end

  resources :festivals, only: [:index, :show]
end
