require 'rails_helper'

RSpec.describe DeleteSubscriptionService, type: :service do
  describe '.call' do
    let(:subscription_id) { 'subscription_id' }
    let(:subscription) { double('Subscription', id: subscription_id) }

    context 'when subscription exists and is paid' do
      it 'cancels the subscription' do
        existing_subscription = instance_double(Subscription, state: 'paid')
        allow(Subscription).to receive(:transaction).and_yield
        allow(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(existing_subscription)

        expect(existing_subscription).to receive(:update!).with(state: :canceled)

        DeleteSubscriptionService.call(subscription)
      end
    end

    context 'when subscription does not exist' do
      it 'does not attempt to cancel the subscription' do
        allow(Subscription).to receive(:transaction).and_yield
        allow(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(nil)

        expect_any_instance_of(Subscription).not_to receive(:update!)

        DeleteSubscriptionService.call(subscription)
      end
    end

    context 'when subscription exists but is not paid' do
      it 'does not attempt to cancel the subscription' do
        existing_subscription = instance_double(Subscription, state: 'unpaid')
        allow(Subscription).to receive(:transaction).and_yield
        allow(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(existing_subscription)

        expect(existing_subscription).not_to receive(:update!)

        DeleteSubscriptionService.call(subscription)
      end
    end

    context 'when an error occurs during deletion' do
      it 'returns an error message' do
        error_message = 'Something went wrong'
        allow(Subscription).to receive(:transaction).and_raise(StandardError, error_message)

        expect(DeleteSubscriptionService.call(subscription)).to eq("Error deleting subscription record: #{error_message}")
      end
    end
  end
end
