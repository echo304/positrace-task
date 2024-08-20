# frozen_string_literal: true

module Api
  module V1
    class ApiKeysController < ApplicationController
      include ApiKeyAuthenticatable

      prepend_before_action :authenticate_with_api_key!, only: %i[index destroy]

      def index
        render json: current_bearer.api_keys
      end

      def create
        authenticate_with_http_basic do |email, password|
          user = User.find_by email: email

          if user&.authenticate(password)
            api_key = user.api_keys.create! token: SecureRandom.hex

            render json: api_key, status: :created and return
          end
        end

        render status: :unauthorized
      end

      def destroy
        begin
          api_key = current_bearer.api_keys.find(params[:id])
          api_key.destroy
        rescue ActiveRecord::RecordNotFound
          render status: :not_found and return
        end
      end
    end
  end
end
