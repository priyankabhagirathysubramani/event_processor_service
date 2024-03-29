# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicePaymentSucceededService, type: :service do
  describe '#call' do
    let(:stripe_subscription) { StripeMock.mock_webhook_event('customer.subscription.created') }
    let(:invoice) { double('Invoice', subscription: stripe_subscription.id) }

    context 'when subscription exists' do
      it 'updates the subscription state to paid' do
        subscription = create(:subscription, stripe_id: stripe_subscription.id, state: 'unpaid')
        class_return = InvoicePaymentSucceededService.call(invoice)
        subscription.reload
        expect(subscription).to be_paid
        expect(class_return).to be_truthy
      end
    end

    context 'when subscription does not exist' do
      it 'does not attempt to change the subscription state' do
        Subscription.find_by(stripe_id: stripe_subscription.id)&.destroy
        class_return = InvoicePaymentSucceededService.call(invoice)
        expect(class_return).to be_nil
      end
    end

     context 'when stripe invoice is not passed' do
      it 'does not attempt to change the subscription state' do
        class_return = InvoicePaymentSucceededService.call(nil)
        expect(class_return).to be_nil
      end
    end

     context 'when stripe invoice does not have a subscription' do
      it 'does not attempt to change the subscription state' do
        new_invoice = double('Invoice', subscription: nil)
        class_return = InvoicePaymentSucceededService.call(new_invoice)
        expect(class_return).to be_nil
      end
    end
  end
end
