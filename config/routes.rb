Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :api_keys, only: %i[index create destroy]
      # resources :api_keys, path: 'api-keys', only: %i[index create destroy]
      scope '/geolocations' do
        get '', to: 'geolocations#show'
        post '', to: 'geolocations#fetch_and_create'
        delete '', to: 'geolocations#destroy'
      end
    end
  end
end
