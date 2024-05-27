class Paymongo::Api::Client
  include Paymongo::Endpoints::CheckoutSessions
  include Paymongo::Endpoints::PaymentIntents
  include Paymongo::Endpoints::PaymentMethods

  BASE_URL = Rails.application.credentials.PAYMONGO_BASE_URL.freeze
  SECRET_KEY = Rails.application.credentials.PAYMONGO_SECRET_KEY.freeze
  PUBLIC_KEY = Rails.application.credentials.PAYMONGO_PUBLIC_KEY.freeze

  private

  def build_headers(headers)
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'Authorization' => "Basic #{Base64.strict_encode64("#{SECRET_KEY}:")}"
    }.merge(headers)
  end

  def request(method:, endpoint:, headers: {}, body: {})
    response = connection.public_send(method, "#{endpoint}") do |request|
      request.headers = build_headers(headers)
      request.body = body
    end

    handle_response(response)
  end

  def handle_response(response)
    case response.status
    when 200..299
      JSON.parse(response.body).with_indifferent_access if response.success?
    else
      Paymongo::Errors::ApiError.handle_error(response)
    end
  end

  def connection
    @connection ||= Faraday.new(url: BASE_URL) do |faraday|
      faraday.adapter Faraday.default_adapter
      faraday.ssl[:verify] = true
    end
  end
end
