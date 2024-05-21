class PaymentsController < ApplicationController
  skip_after_action :verify_authorized, only: :index

  def index
    client = Paymongo::Api::Client.new
    attributes = {
      send_email_receipt: false,
      show_description: true,
      show_line_items: true,
      line_items: [
        { currency: 'PHP', name: 'test', quantity: 1, amount: 10000 }
      ],
      payment_method_types: ['gcash'],
      description: 'this is a test description'
    }

    @response = client.create_checkout_session(attributes)
  end
end
