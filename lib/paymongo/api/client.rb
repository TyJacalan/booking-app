class Paymongo::Api::Client
  BASE_URL = Rails.application.credentials.PAYMONGO_BASE_URL.freeze
  SECRET_KEY = Rails.application.credentials.PAYMONGO_SECRET_KEY.freeze
  PUBLIC_KEY = Rails.application.credentials.PAYMONGO_PUBLIC_KEY.freeze

  private

  def request(method:, endpoint:, params: {}, headers: {}, body: {})
    response = connection.public_send(method, "#{endpoint}") do |request|
      request.params = params if params.present?
      request.headers = headers if headers.present?
      request.body = body.to_json if body.present?
    end

    handle_response(response)
  end

  def handle_response(response)
    case response.status
    when 200..299
      JSON.parse(response.body).with_indifferent_access if response.success?
    when 404
      raise Faraday::ResourceNotFound, response.body
    else
      # to do: handle client errors
      raise 'Something went wrong!'
    end
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL)
  end
end
