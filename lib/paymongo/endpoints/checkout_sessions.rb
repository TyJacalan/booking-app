module Paymongo
  module Endpoints
    module CheckoutSessions
      def create_checkout_session(params)
        body = build_body(data: { attributes: params })
        request(
          method: :post,
          endpoint: 'checkout_sessions',
          body: body
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

      private

      def build_body(body)
        {
          send_email_receipt: false,
          show_description: true,
          show_line_items: true
        }.merge(body).to_json
      end
    end
  end
end
