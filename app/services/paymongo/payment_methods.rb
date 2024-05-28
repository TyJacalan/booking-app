module Paymongo
  class PaymentMethods
    def self.call(method, params, **options)
      client = Paymongo::Api::Client.new
      response = client.send(method, params, **options)

      raise StandardError.new("#{response[:error]}") unless response[:data]
      response[:data]
    end
 
    def self.create(payment_intent_id, params)
      params = {
        type: params[:payment_method],
        details: {
          card_number: params[:card_number],
          exp_month: params[:exp_month].to_i,
          exp_year: params[:exp_year].to_i,
          cvc: params[:cvc]
        },
        billing: {
          name: params[:name],
          email: params[:email],
          phone: params[:phone]
        }
      }

      call(:create_payment_method, params)
    end
  end
end
