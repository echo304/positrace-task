# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geolocation, type: :model do
  context "validation tests" do
    describe "ip address" do
      it "is invalid without ip address" do
        geolocation = Geolocation.new(
          country: "Ireland",
          region: nil,
          city: nil,
          lat: 53.0,
          lon: -8.0
        )

        expect(geolocation).to_not be_valid
      end

      it "is invalid with invalid ip address" do
        geolocation = Geolocation.new(
          ip_address: "invalid ip address",
          country: "Ireland",
          region: nil,
          city: nil,
          lat: 53.0,
          lon: -8.0
        )

        expect(geolocation).to_not be_valid
      end

      context "when ip address is valid" do
        %w[
          127.1.1.1
          255.255.255.255
          1.1.1.1
          0.0.0.0
          2001:db8:3333:4444:5555:6666:1.2.3.4
          2607:f8b0:400a:806::2002
          2001:db8:3333:4444:5555:6666:7777:8888
          2001:db8:3333:4444:CCCC:DDDD:EEEE:FFFF
          ::
          2001:db8::
          ::1234:5678
          2001:db8::1234:5678
          2001:0db8:0001:0000:0000:0ab9:C0A8:0102
          ::11.22.33.44
          2001:db8::123.123.123.123
          ::1234:5678:91.123.4.56
          ::1234:5678:1.2.3.4
          2001:db8::1234:5678:5.6.7.8
        ].each do |ip_address|
          describe "ip_address: #{ip_address}" do
            it "is valid" do
              geolocation = Geolocation.new(
                ip_address: ip_address,
                country: "Ireland",
                region: nil,
                city: nil,
                lat: 53.0,
                lon: -8.0
              )

              expect(geolocation).to be_valid
            end
          end
        end

      end
    end

    describe "country" do
      it "is invalid without country" do
        geolocation = Geolocation.new(
          ip_address: "2a03:2880:f101:83:face:b00c:0:25de",
          region: nil,
          city: nil,
          lat: 53.0,
          lon: -8.0
        )

        expect(geolocation).to_not be_valid
      end
    end

    describe "lat" do
      it "is invalid without lat" do
        geolocation = Geolocation.new(
          ip_address: "2a03:2880:f101:83:face:b00c:0:25de",
          country: "Ireland",
          region: nil,
          city: nil,
          lon: -8.0
        )

        expect(geolocation).to_not be_valid
      end

      it "is invalid with invalid lat" do
        geolocation = Geolocation.new(
          ip_address: "2a03:2880:f101:83:face:b00c:0:25de",
          country: "Ireland",
          region: nil,
          city: nil,
          lat: 100.0,
          lon: -8.0
        )

        expect(geolocation).to_not be_valid
      end
    end

    describe "lon" do
      it "is invalid without lon" do
        geolocation = Geolocation.new(
          ip_address: "2a03:2880:f101:83:face:b00c:0:25de",
          country: "Ireland",
          region: nil,
          city: nil,
          lat: 53.0
        )

        expect(geolocation).to_not be_valid
      end

      it "is invalid with invalid lon" do
        geolocation = Geolocation.new(
          ip_address: "2a03:2880:f101:83:face:b00c:0:25de",
          country: "Ireland",
          region: nil,
          city: nil,
          lat: 53.0,
          lon: 200.0
        )

        expect(geolocation).to_not be_valid
      end
    end
  end
end
