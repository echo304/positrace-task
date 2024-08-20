# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ApiKeysController, type: :controller do

  it_should_authenticate_for_actions [:index, "GET"], [:destroy, "DELETE"]

  context 'index' do

    it 'should return current user\'s api key list without actual token' do
      authenticate_with_token
      get :index
      response_body = JSON.parse(response.body)
      expect(response.status).to be(200)
      expect(response_body.count).to eq(1)
      expect(response_body.first).to_not include("token")
    end
  end

  context 'create' do

      it 'should create new api key for user' do
        u = User.create!(email: "new_token@test.com", password: "password")
        expect(u.api_keys.count).to eq(0)

        request.headers["Authorization"] = ActionController::HttpAuthentication::Basic.encode_credentials("new_token@test.com", "password")
        post :create
        response_body = JSON.parse(response.body)

        expect(response.status).to eq(201)
        expect(response_body).to include("token")
        expect(u.api_keys.count).to eq(1)
      end

      it 'should return 401 if user is not authenticated' do
        post :create
        expect(response.status).to eq(401)
      end
  end

  context 'destroy' do

      it 'should delete current user\'s api key' do
        authenticate_with_token
        u = User.find_by email: "authorized-user@test.com"
        api_key_id = u.api_keys.last.id
        delete :destroy, params: { id: api_key_id }

        expect(response.status).to be(204)
        expect(u.api_keys.count).to eq(0)
      end

      it 'should return 404 if api key with given id does not exist' do
        authenticate_with_token
        u = User.find_by email: "authorized-user@test.com"
        delete :destroy, params: { id: -1 }

        expect(response.status).to be(404)
        expect(u.api_keys.count).to eq(1)
      end
  end
end
