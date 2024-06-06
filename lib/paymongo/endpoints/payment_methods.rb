module Paymongo
  module Endpoints
    module PaymentMethods
      def create_payment_method(params)
        body = { data: { attributes: params } }
        request(
          method: :post,
          endpoint: 'payment_methods',
          body: body.to_json
        )
      end

      def retrieve_payment_method(id)
        request(
          method: :get,
          endpoint: "payment_methods/#{id}"
        )
      end

      def update_payment_method(id)
        body = { data: { attributes: params } }
        request(
          method: :patch,
          endpoint: "payment_methods/#{id}",
          body: body.to_json
        )
      end
    end
  end
end
