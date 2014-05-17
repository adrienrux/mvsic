Rails.application.routes.draw do

  namespace :api do
    resources :festivals, only: [:index, :show]
  end

end
