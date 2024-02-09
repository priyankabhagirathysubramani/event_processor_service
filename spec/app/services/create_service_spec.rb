require 'rails_helper'

RSpec.describe CreateService, type: :service do
  describe '.call' do
    let(:subscription_id) { 'subscription_id' }
    let(:subscription) { double('Subscription', id: subscription_id) }

    context 'when subscription does not exist' do
      it 'creates a new subscription with unpaid state' do
        expect(Subscription).to receive(:transaction).and_yield
        expect(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(nil)
        expect(Subscription).to receive(:create!).with(stripe_id: subscription_id)

        CreateService.call(subscription)
      end
    end

    context 'when subscription already exists' do
      it 'does not create a new subscription' do
        existing_subscription = double('Subscription')
        allow(Subscription).to receive(:transaction).and_yield
        allow(Subscription).to receive(:find_by).with(stripe_id: subscription_id).and_return(existing_subscription)

        expect(Subscription).not_to receive(:create!)

        CreateService.call(subscription)
      end
    end

    context 'when an error occurs' do
      it 'returns error message' do
        error_message = 'Something went wrong'
        allow(Subscription).to receive(:transaction).and_raise(StandardError, error_message)

        expect(CreateService.call(subscription)).to eq("Error creating subscription record: #{error_message}")
      end
    end
  end
end
