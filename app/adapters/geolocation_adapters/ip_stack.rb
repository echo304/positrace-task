# frozen_string_literal: true

module GeolocationAdapters
  class IpStack
    include Retryable

    def fetch_geolocation(ip)
      ip_stack_response = with_retries do connection.get("/#{ip}").body end
      IpStackResponse.new(ip_stack_response).to_geolocation
    end

    private

    def connection
      @connection ||= Faraday.new(
        url: ENV['GEOLOCATION_URL'],
        params: { access_key: ENV['GEOLOCATION_ACCESS_KEY'] },
        request: { open_timeout: 10, timeout: 30 }
        ) do |builder|
        builder.request :json
        builder.response :json
        builder.response :raise_error
        builder.response :logger
      end
    end
  end

  class IpStackResponse
    def initialize(res)
      if res["success"] == false
        raise GeolocationServiceError, "Unsuccessful response from Geolocation service"
      end

      @ip = res["ip"]
      @continent_name = res["continent_name"]
      @country_name = res["country_name"]
      @region_name = res["region_name"]
      @city = res["city"]
      @latitude = res["latitude"]
      @longitude = res["longitude"]
    end

    # It is used to decouple the service provider from the controller and model
    # It allows domain model Geolocation not to be affected by unexpected changes in the service provider response
    def to_geolocation
      Geolocation.new(
        ip_address: @ip,
        country: @country_name,
        region: @region_name,
        city: @city,
        lat: @latitude,
        lon: @longitude
      )
    end
  end
end
