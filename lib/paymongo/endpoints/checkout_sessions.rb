module Paymongo
  module Endpoints
    module CheckoutSessions
      def create_checkout_session(params)
        body = { data: { attributes: params } }
        request(
          method: :post,
          endpoint: 'checkout_sessions',
          body: body.to_json
        )
      end

      def retrieve_checkout_session(id)
        request(
          method: :get,
          endpoint: "checkout_sessions/#{id}"
        )
      end

      def expire_checkout_session(id)
        request(
          method: :post,
          endpoint: "checkout_sessions/#{id}"
        )
      end
    end
  end
end
