# frozen_string_literal: true

class GeolocationClient
  cattr_accessor :adapter
  self.adapter = IpStack

  def initialize
    @client = adapter.new
  end

  def fetch_geolocation(ip)
    begin
      @client.fetch_geolocation(ip)
    rescue Error => e
      Rails.logger.error("Call to Geolocation external service failed: #{e.message}")
      raise GeolocationClientError, e.message
    end
  end

  class GeolocationClientError < StandardError; end
end

