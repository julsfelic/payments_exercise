Rails.application.routes.draw do
  resources :loans, defaults: { format: :json }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :loans, only: [:show] do
        resources :payments, only: [:index, :show, :create]
      end
    end
  end
end
