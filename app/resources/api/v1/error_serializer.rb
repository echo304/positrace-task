# frozen_string_literal: true

module Api
  module V1
    class ErrorSerializer
      def initialize(errors)
        @errors = errors
      end

      def serialize_json
        {
          errors: @errors.map do |error|
            {
              status: error.status_code.to_s,
              title: error.message
            }
          end
        }
      end

      class ErrorMessage
        attr_reader :message, :status_code

        def initialize(message, status_code)
          @message = message
          @status_code = status_code
        end
      end
    end
  end
end

