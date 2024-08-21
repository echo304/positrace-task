# frozen_string_literal: true

module Api
  module V1
    class GeolocationsController < ApplicationController
      include ApiKeyAuthenticatable
      include EndpointHelper

      prepend_before_action :authenticate_with_api_key!, only: %i[ index show create destroy]
      before_action :validate_endpoint, only: %i[ create ]
      before_action :set_geolocation, only: %i[ show destroy ]
      wrap_parameters false

      rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
      rescue_from ActionController::BadRequest, with: :bad_request_response

      # Filtering
      # Only filtering by ip_address is supported
      #
      # GET /geolocations?filter[ip_address]=
      #
      # Pagination
      # Works with cursor based pagination
      # In this case, we are using the id as the cursor to paginate the records
      # because the id is auto-incremented and unique.
      # As a trade-off, we are limiting sorting capabilities.
      #
      # GET /geolocations?page[limit]=10&page[cursor]=11
      def index
        begin
          @geolocations = Geolocation.all

          if params[:filter].present?
            filters = params[:filter].permit(:ip_address)
            @geolocations = @geolocations.where(filters.to_h)
          end

          if params[:page].present?
            cursor = params[:page][:cursor].to_i
            limit = params[:page][:limit].to_i || 10
            @geolocations = @geolocations.where('id >= ?', cursor).limit(limit)

            last_record_id = Geolocation.last.id
            first_record_id = Geolocation.first.id

            links = {
              first: nil,
              last: nil,
              prev: nil,
              next: nil
            }
            if @geolocations.count >= limit
              links[:first] = url_for(page: { cursor: first_record_id, limit: limit })
              links[:last] = url_for(page: { cursor: last_record_id - limit + 1, limit: limit })
              links[:prev] = cursor > first_record_id ? url_for(page: { cursor: [cursor - limit, first_record_id].max, limit: limit }) : nil
              links[:next] = cursor + limit <= last_record_id ? url_for(page: { cursor: cursor + limit, limit: limit }) : nil
            end
          end

        rescue Exception => e
          render json: ErrorSerializer.new([ErrorSerializer::ErrorMessage.new(e.message, 500)])
                                      .serialize_json, status: :internal_server_error
          return
        end

        render jsonapi: @geolocations,
               class: { Geolocation: Api::V1::SerializableGeolocation },
               links: links
      end

      # GET /geolocations/1
      def show
        render jsonapi: @geolocation,
               class: { Geolocation: Api::V1::SerializableGeolocation }
      end

      # POST /geolocations
      # {
      #  "endpoint": "1.1.1.1"
      # }
      def create
        ip = convert_endpoint_to_ip(geolocation_params[:endpoint])
        begin
          @geolocation = GeolocationClient.new.fetch_geolocation(ip)
        rescue GeolocationClient::GeolocationClientError => e
          logger.error("Failed to fetch geolocation_adapters from external service: #{e.message}")
          logger.error e.backtrace.join("\n")
          render json: ErrorSerializer.new([ErrorSerializer::ErrorMessage.new("Failed to fetch geolocation_adapters from external service: #{e.message}", 503)])
                                       .serialize_json, status: :service_unavailable
          return
        end

        if @geolocation.save
          logger.info("Geolocation saved for #{params[:endpoint]}")
          render jsonapi: @geolocation,
                 class: { Geolocation: Api::V1::SerializableGeolocation },
                 status: :created
        else
          logger.error("Failed to save Geolocation #{@geolocation.errors.full_messages}")
          render jsonapi: ErrorSerializer.new(
            @geolocation.errors.map do |error|
              ErrorSerializer::ErrorMessage.new(error.message, 422)
            end).serialize_json, status: :unprocessable_entity
        end
      end

      # DELETE /geolocations/1
      def destroy
        @geolocation.destroy!
      end

      private

      def not_found_response(exception)
        logger.info("Geolocation not found for #{params[:id]}")
        render json: ErrorSerializer.new([ErrorSerializer::ErrorMessage.new(exception.message, 404)])
                                    .serialize_json, status: :not_found
      end

      def bad_request_response(exception)
        logger.info("Bad request: #{exception.message}")
        render json: ErrorSerializer.new([ErrorSerializer::ErrorMessage.new(exception.message, 400)])
                                    .serialize_json, status: :bad_request
      end

      def validate_endpoint
        case parse_endpoint(geolocation_params[:endpoint])
        when :url
          return
        when :ipv4
          return
        when :ipv6
          return
        else
          raise ActionController::BadRequest.new("Invalid endpoint")
        end
      end

      def set_geolocation
        @geolocation = Geolocation.find(params[:id])
      end

      def geolocation_params
        params.require(:endpoint)
        params.permit(:endpoint)
      end

      def convert_endpoint_to_ip(endpoint)
        if parse_endpoint(endpoint) == :url
          endpoint = URI.parse(endpoint).host || endpoint
        end

        begin
          IPSocket::getaddress(endpoint)
        rescue SocketError => e
          logger.error("Failed to get ip address: #{e.message}")
          logger.error e.backtrace.join("\n")
          raise ActionController::BadRequest.new("Invalid endpoint(url) is provided")
        end
      end
    end
  end
end

