Rails.application.routes.draw do
  resources :bikes, only: [:index]
  
  namespace :api do
    namespace :bikes do
      resources :database, only: [:index]
    end
  end
end
