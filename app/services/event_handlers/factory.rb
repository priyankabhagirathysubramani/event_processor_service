# frozen_string_literal: true

module EventHandlers
  # Factory is a service object responsible for dynamically selecting the appropriate
  # service class based on the type of incoming Stripe webhook event.
  class Factory < ApplicationService
    # Initializes a new instance of the Factory.
    #
    # @param event_type [String] The type of the incoming Stripe webhook event.
    def initialize(event_type)
      @event_type = event_type
    end

    # Dynamically selects the appropriate service class based on the event type.
    #
    # @return [Class] The service class corresponding to the event type, or nil if no match is found.
    def call
      case event_type
      when 'customer.subscription.created'
        CreateSubscriptionService
      when 'invoice.payment_succeeded'
        InvoicePaymentSucceededService
      when 'customer.subscription.deleted'
        DeleteSubscriptionService
      else 
        nil
      end
    end

    private

    attr_reader :event_type
  end
end
