# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GeolocationAdapters::IpStack' do
  let(:ip) { '10.231.9.12' }

  it "returns with converted Geolocation" do
    ip_stack_adapter = GeolocationAdapters::IpStack.new
    connection = ip_stack_adapter.send(:connection)
    expect(connection).to receive(:get).once.and_return(double(body: { "success" => true, "ip" => ip, "country_name" => "United States", "region_name" => "California", "city" => "Los Angeles", "latitude" => 34.0522, "longitude" => -118.2437 }))

    actual = ip_stack_adapter.fetch_geolocation(ip)
    expect(actual).to be_a(Geolocation)
    expect(actual.ip_address).to eq(ip)
  end

  it "retries read timeout errors" do
    ip_stack_adapter = GeolocationAdapters::IpStack.new
    connection = ip_stack_adapter.send(:connection)
    expect(connection).to receive(:get).once.and_raise(Faraday::TimeoutError)
    expect(connection).to receive(:get).once.and_return(double(body: { "success" => true, "ip" => ip, "country_name" => "United States", "region_name" => "California", "city" => "Los Angeles", "latitude" => 34.0522, "longitude" => -118.2437 }))
    allow_any_instance_of(Retryable).to receive(:sleep_interval).and_return(0)

    actual = ip_stack_adapter.fetch_geolocation(ip)
    expect(actual).to be_a(Geolocation)
    expect(actual.ip_address).to eq(ip)
  end

  it "re-raises read timeout error after exausting error retries" do
    ip_stack_adapter = GeolocationAdapters::IpStack.new
    connection = ip_stack_adapter.send(:connection)
    expect(connection).to receive(:get).exactly(4).times.and_raise(Faraday::TimeoutError)
    allow_any_instance_of(Retryable).to receive(:sleep_interval).and_return(0)

    expect {
      expect(ip_stack_adapter.fetch_geolocation(ip))
    }.to raise_error(Faraday::TimeoutError)
  end

  it "raise if response is not success" do
    ip_stack_adapter = GeolocationAdapters::IpStack.new
    connection = ip_stack_adapter.send(:connection)
    expect(connection).to receive(:get).once.and_return(double(body: { "success" => false }))

    expect {
      ip_stack_adapter.fetch_geolocation(ip)
    }.to raise_error(GeolocationServiceError)
  end
end
