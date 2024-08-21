# frozen_string_literal: true

module GeolocationAdapters
  class AnotherGeolocationProvider
    include Retryable
    def fetch_geolocation(ip)
      # Implementation goes here
    end
  end
end
