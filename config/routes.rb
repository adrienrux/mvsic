Rails.application.routes.draw do
  root to: 'angular#index'

  namespace :api do
    resources :festivals, only: [:index, :show]
    resources :schedules, only: [:create, :show, :update]
  end

  namespace :beta do
    post :signup
    post :feedback
  end

  post 'track', controller: :tracker, action: :update

  get '*path' => 'angular#index'
end
