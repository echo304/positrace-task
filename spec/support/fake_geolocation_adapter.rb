# frozen_string_literal: true

class FakeGeolocationAdapter
  def fetch_geolocation(ip)
    Geolocation.new(
      ip_address: ip,
      country: 'United States',
      region: 'California',
      city: 'Los Angeles',
      lat: 34.052235,
      lon: -118.243683
    )
  end
end
