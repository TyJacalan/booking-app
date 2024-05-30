# frozen_string_literal: true

module Paymongo
  module Errors
    class ApiError < StandardError
      attr_reader :code, :detail

      def initialize(code, detail)
        @code = code
        @detail = detail
        super("#{code}: #{detail}")
      end

      def self.handle_error(response)
        raise ClientError, 'Empty response from Api' if response.body.blank?

        error_data = JSON.parse(response.body)
        raise ApiError.new(error_data['errors'].first['code'], error_data['errors'].first['detail']) if error_data.key?('errors')

        raise ClientError, "Unknown API error: #{response.body}"
      end
    end
  end
end
