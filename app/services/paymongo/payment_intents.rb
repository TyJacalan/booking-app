module Paymongo
  class PaymentIntents
    def self.call(method, params, **options)
      client = Paymongo::Api::Client.new
      response = if options[:id]
                   client.send(method, options[:id], params)
                 else
                   client.send(method, params)
                 end

      raise StandardError.new("#{response[:error]}") unless response[:data]
      response[:data]
    end

    def self.create(amount)
      params = {
        currency: 'PHP',
        amount: amount,
        payment_method_allowed: ['card', 'gcash', 'paymaya']
      }

      call(:create_payment_intent, params)
    end

    def self.attach(payment_intent_id, payment_method_id)
      params = {
        payment_method: payment_method_id,
        return_url: 'http://127.0.0.1:3000/'
      }

      call(:attach_payment_intent, params, id: payment_intent_id)
    end
  end
end
