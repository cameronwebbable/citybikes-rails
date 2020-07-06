Rails.application.routes.draw do
  namespace :api do
    namespace :bikes do
      resources :database, only: [:index]
    end
  end
end
