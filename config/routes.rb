Rails.application.routes.draw do
  root to: 'angular#index'

  namespace :api do
    resources :festivals, only: [:index, :show]
  end

  namespace :beta do
    post :signup
  end

  get '*path' => 'angular#index'
end
