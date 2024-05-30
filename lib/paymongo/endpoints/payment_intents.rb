module Paymongo
  module Endpoints
    module PaymentIntents
      def create_payment_intent(params)
        body = { data: { attributes: params } }
        request(
          method: :post,
          endpoint: 'payment_intents',
          body: body.to_json
        )
      end

      def retrieve_payment_intent(id)
        request(
          method: :get,
          endpoint: "payment_intents/#{id}"
        )
      end

      def attach_payment_intent(id, params)
        body = { data: { attributes: params } }
        request(
          method: :post,
          endpoint: "payment_intents/#{id}/attach",
          body: body.to_json
        )
      end
    end
  end
end
