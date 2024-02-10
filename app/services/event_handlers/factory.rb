# frozen_string_literal: true

module EventHandlers
  class Factory < ApplicationService
    def initialize(event_type)
      @event_type = event_type
    end

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
