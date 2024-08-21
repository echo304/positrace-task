# frozen_string_literal: true

class GeolocationClient
  cattr_accessor :adapter

  # Adapter is set to IpStack by default
  # To change the adapter, set the adapter to the desired adapter class
  # Example: GeolocationClient.adapter = AnotherGeolocationProvider
  # The adapter class must implement a fetch_geolocation method that returns a Geolocation object
  self.adapter = GeolocationAdapters::IpStack

  def initialize
    @client = adapter.new
  end

  def fetch_geolocation(ip)
    begin
      @client.fetch_geolocation(ip)
    rescue StandardError => e
      Rails.logger.error("Call to Geolocation external service failed: #{e.message}")
      raise GeolocationClientError, e.message
    end
  end

  class GeolocationClientError < StandardError; end
end

