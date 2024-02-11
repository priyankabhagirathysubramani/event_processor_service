# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventHandlers::Factory, type: :service do
  describe '#call' do
    context 'when event type is customer.subscription.created' do
      it 'returns an instance of CreateSubscriptionService' do
        service = EventHandlers::Factory.call('customer.subscription.created')
        expect(service).to eq(CreateSubscriptionService)
      end
    end

    context 'when event type is invoice.payment_succeeded' do
      it 'returns an instance of InvoicePaymentSucceededService' do
        service = EventHandlers::Factory.call('invoice.payment_succeeded')
        expect(service).to eq(InvoicePaymentSucceededService)
      end
    end

    context 'when event type is customer.subscription.deleted' do
      it 'returns an instance of DeleteSubscriptionService' do
        service = EventHandlers::Factory.call('customer.subscription.deleted')
        expect(service).to eq(DeleteSubscriptionService)
      end
    end

    context 'when event type is unknown' do
      it 'returns nil' do
        service = EventHandlers::Factory.call('unknown_event_type')
        expect(service).to be_nil
      end
    end
  end
end
