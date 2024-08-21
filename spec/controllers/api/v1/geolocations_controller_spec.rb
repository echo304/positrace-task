# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GeolocationsController, type: :controller do
  let(:geolocation) { create(:geolocation) }
  let(:geolocations) { create_list(:geolocation, 20) }

  it_should_authenticate_for_actions [:index, "GET"], [:show, "GET"], [:create, "POST"], [:destroy, "DELETE"]

  context 'with valid authentication' do
    before do
      authenticate_with_token
      end

    describe 'GET #index' do
      context 'with valid filter' do
        it 'returns filtered geolocations' do
          get :index, params: { filter: { ip_address: geolocation.ip_address } }
          expect(response).to have_http_status(:ok)
          expect(json_response['data'].first['attributes']['ip_address']).to eq(geolocation.ip_address)
        end
      end

      context 'with pagination' do
        it 'returns paginated geolocations' do
          get :index, params: { page: { cursor: geolocations.first.id, limit: 10 } }
          expect(response).to have_http_status(:ok)
          expect(json_response['data'].size).to eq(10)
          expect(json_response['data'].first['id']).to eq(geolocations[0].id.to_s)
        end

        it 'returns pagination links' do
          get :index, params: { page: { cursor: geolocations.first.id, limit: 10 } }
          expect(response).to have_http_status(:ok)
          expect(json_response['links']).to include('first', 'last', 'prev', 'next')
        end
      end
    end

    describe 'GET #show' do
      context 'when geolocation exists' do
        it 'returns the geolocation' do
          get :show, params: { id: geolocation.id }
          expect(response).to have_http_status(:ok)
          expect(json_response['data']['attributes']['ip_address']).to eq(geolocation.ip_address)
        end
      end

      context 'when geolocation does not exist' do
        it 'returns not found' do
          get :show, params: { id: 0 }
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe 'POST #create' do
      before do
        GeolocationClient.adapter = FakeGeolocationAdapter
      end

      context 'with valid params' do
        it 'creates a new geolocation' do
          post :create, params: { endpoint: '1.1.1.1' }
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid params' do
        it 'returns an error' do
          post :create, params: { endpoint: 'invalid' }
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    describe 'DELETE #destroy' do
      context 'when geolocation exists' do
        it 'deletes the geolocation' do
          delete :destroy, params: { id: geolocation.id }
          expect(response).to have_http_status(:no_content)
        end
      end

      context 'when geolocation does not exist' do
        it 'returns not found' do
          delete :destroy, params: { id: 0 }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

end
