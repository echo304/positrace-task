Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :api_keys, only: %i[index create destroy]
      # resources :api_keys, path: 'api-keys', only: %i[index create destroy]
      # get '/geolocations', to: 'geolocations#index'
      # get '/geolocations/:id', to: 'geolocations#show'
      # post '/geolocations', to: 'geolocations#create'
      # delete '/geolocations', to: 'geolocations#destroy'

      resources :geolocations, only: %i[index show create destroy]
    end
  end
end
