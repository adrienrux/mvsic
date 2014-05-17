Rails.application.routes.draw do
  root to: 'angular#index'

  namespace :api do
    resources :festivals, only: [:index, :show]
  end

  get '*path' => 'angular#index'
end
