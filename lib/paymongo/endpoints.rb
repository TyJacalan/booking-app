module Paymongo
  module Endpoints
    autoload :CreateSessions, 'paymongo/endpoints/checkout_sessions'
    autoload :PaymentIntents, 'paymongo/endpoints/payment_intents'
    autoload :PaymentMethods, 'paymongo/endpoints/payment_methods'
  end
end
