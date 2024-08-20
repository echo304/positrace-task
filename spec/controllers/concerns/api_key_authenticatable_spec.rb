# frozen_string_literal: true

require 'rails_helper'

describe 'ApiKeyAuthenticatable', type: :controller do
  controller do
    include ApiKeyAuthenticatable
    prepend_before_action :authenticate_with_api_key!, only: %i[fake_action]

    def fake_action
      render json: { message: "success" }
    end
  end

  let(:token) { "abc" }

  before {
    routes.draw { get "/fake_action" => "anonymous#fake_action" }
    u = User.create!(email: "test@test.com", password: "password")
    u.api_keys.create! token: token
  }

  describe "#authenticate_with_api_key!" do
    it "authenticate with proper api key" do
      request.headers["Authorization"] = "Bearer abc"
      get :fake_action
      expect(response.status).to be(200)
    end

    it "doesn't authenticate with wrong api key" do
      request.headers["Authorization"] = "Bearer wrong"
      get :fake_action
      expect(response.status).to be(401)
    end
  end
end
