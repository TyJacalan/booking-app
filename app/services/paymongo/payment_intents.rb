module Paymongo
  class PaymentIntents
    def self.create(amount)
      params = {
        currency: 'PHP',
        amount: amount,
        payment_method_allowed: ['card', 'gcash', 'paymaya']
      }

      client = Paymongo::Api::Client.new
      response = client.create_payment_intent(params)
      handle_response(response)
    end

    def self.handle_response(response)
      raise StandardError.new("#{response[:error]}") unless response[:data]
      response[:data]
    end
  end
end
