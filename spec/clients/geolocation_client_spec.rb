# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GeolocationClient' do
  context 'when underlying adapter succeeds to fetch data' do
    it 'succeeds' do
      GeolocationClient.adapter = FakeGeolocationAdapter
      client = GeolocationClient.new
      geolocation = client.fetch_geolocation('1.1.1.1')
      expect(geolocation.ip_address).to eq('1.1.1.1')
      expect(geolocation).to be_an_instance_of(Geolocation)
    end
  end

  context 'when underlying adapter fails to fetch data' do
    it 'raises an error' do
      allow_any_instance_of(FakeGeolocationAdapter).to receive(:fetch_geolocation).and_raise(Faraday::TimeoutError)
      GeolocationClient.adapter = FakeGeolocationAdapter
      client = GeolocationClient.new
      expect { client.fetch_geolocation('1.1.1.1') }.to raise_error(GeolocationClient::GeolocationClientError)
    end
  end
end
