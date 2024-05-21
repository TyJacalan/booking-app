module Paymongo
  module Endpoints
    module CheckoutSessions
      def create_checkout_session(params)
        body = { data: { attributes: params } }
        request(
          method: :post,
          endpoint: 'checkout_sessions',
          body: body
        )
      end
    end
  end
end
