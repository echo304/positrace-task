# frozen_string_literal: true

module Api
  module V1
    class SerializableGeolocation < JSONAPI::Serializable::Resource
      type 'geolocations'

      attributes :ip_address, :country, :region, :city, :lat, :lon

      link :self do
        print @url_helpers
        @url_helpers.api_v1_geolocation_url(@object.id)
      end
    end
  end
end
