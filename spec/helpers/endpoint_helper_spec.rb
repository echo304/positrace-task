# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointHelper, type: :helper do
  # let(:cls) { Class.new { extend EndpointHelper } }
  context "when called with valid url" do
    [
      { input: 'http://example.com', expected: :url },
      { input: 'example.com', expected: :url },
      { input: 'foo.example.com', expected: :url },
    ].each do |t|
      describe "input #{t[:input]}" do
        it "returns #{t[:expected]}" do
          expect(helper.parse_endpoint(t[:input])).to eq(t[:expected])
        end
      end
    end
  end

  context 'when called with valid ipv4' do
    [
      { input: '127.1.1.1', expected: :ipv4 },
      { input: '255.255.255.255', expected: :ipv4 },
      { input: '1.1.1.1', expected: :ipv4 },
      { input: '0.0.0.0', expected: :ipv4 },
    ].each do |t|
      describe "input #{t[:input]}" do
        it "returns #{t[:expected]}" do
          expect(helper.parse_endpoint(t[:input])).to eq(t[:expected])
        end
      end
    end
  end

  context 'when called with valid ipv6' do
    [
      { input: '2001:db8:3333:4444:5555:6666:1.2.3.4', expected: :ipv6 },
      { input: '2607:f8b0:400a:806::2002', expected: :ipv6 },
      { input: '2001:db8:3333:4444:5555:6666:7777:8888', expected: :ipv6 },
      { input: '2001:db8:3333:4444:CCCC:DDDD:EEEE:FFFF', expected: :ipv6 },
      { input: '::', expected: :ipv6 },
      { input: '2001:db8::', expected: :ipv6 },
      { input: '::1234:5678', expected: :ipv6 },
      { input: '2001:db8::1234:5678', expected: :ipv6 },
      { input: '2001:0db8:0001:0000:0000:0ab9:C0A8:0102', expected: :ipv6 },
      { input: '::11.22.33.44', expected: :ipv6 },
      { input: '2001:db8::123.123.123.123', expected: :ipv6 },
      { input: '::1234:5678:91.123.4.56', expected: :ipv6 },
      { input: '::1234:5678:1.2.3.4', expected: :ipv6 },
      { input: '2001:db8::1234:5678:5.6.7.8', expected: :ipv6 },
    ].each do |t|
      describe "input #{t[:input]}" do
        it "returns #{t[:expected]}" do
          expect(helper.parse_endpoint(t[:input])).to eq(t[:expected])
        end
      end
    end
  end
end

