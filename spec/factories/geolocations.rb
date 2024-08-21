# frozen_string_literal: true

FactoryBot.define do
  factory :geolocation do
    ip_address { Faker::Internet.ip_v4_address }
    country { Faker::Address.country }
    region { Faker::Address.state }
    city { Faker::Address.city }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end