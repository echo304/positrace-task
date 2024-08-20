# frozen_string_literal: true

require 'resolv'
class Geolocation < ApplicationRecord
  validates :ip_address, presence: true, uniqueness: true, format: { with: Resolv::AddressRegex }
  validates :country, presence: true
  validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
