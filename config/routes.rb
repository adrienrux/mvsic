Rails.application.routes.draw do
  root to: 'angular#index'

  namespace :api do
    resources :festivals, only: [:index, :show]
    resources :schedules, only: [:create, :show, :update]
  end

  resources :schedules, only: :show

  namespace :beta do
    post :signup
  end

  post 'track', controller: :tracker, action: :update

  get '*path' => 'angular#index'
end
