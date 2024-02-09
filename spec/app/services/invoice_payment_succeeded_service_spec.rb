require 'rails_helper'

RSpec.describe InvoicePaymentSucceededService, type: :service do
  describe '.call' do
    let(:subscription_id) { 'subscription_id' }
    let(:subscription) { double('Subscription', id: subscription_id, state: :unpaid) }

    context 'when subscription exists' do
      it 'changes the subscription state to paid' do
        existing_subscription = instance_double(Subscription)
        allow(Subscription).to receive(:transaction).and_yield
        allow(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(existing_subscription)

        expect(existing_subscription).to receive(:update!).with(state: :paid)

        InvoicePaymentSucceededService.call(subscription_id)
      end
    end

    context 'when subscription does not exist' do
      it 'does not attempt to change the subscription state' do
        allow(Subscription).to receive(:transaction).and_yield
        allow(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(nil)

        expect(Subscription).not_to receive(:update!)

        InvoicePaymentSucceededService.call(subscription_id)
      end
    end

    context 'when an error occurs during state change' do
      it 'returns an error message' do
        error_message = 'Something went wrong'
        allow(Subscription).to receive(:transaction).and_raise(StandardError, error_message)

        expect(InvoicePaymentSucceededService.call(subscription_id)).to eq("Error changing subscription state: #{error_message}")
      end
    end
  end
end
