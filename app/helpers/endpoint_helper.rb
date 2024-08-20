# frozen_string_literal: true
require 'resolv'

module EndpointHelper
  URL_REGEX = /((ftp|http|https):\/\/)?(\w+:?\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@\-\/]))?/

  def parse_endpoint(endpoint)
    if endpoint.match?(Resolv::IPv4::Regex)
      return :ipv4
    end

    if endpoint.match?(Resolv::IPv6::Regex)
      return :ipv6
    end

    # URL regex covers both ipv4 and ipv6 so it should be checked last
    if endpoint.match?(URL_REGEX)
      return :url
    end

    :unknown
  end
end
