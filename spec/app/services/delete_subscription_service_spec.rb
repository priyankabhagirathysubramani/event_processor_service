require 'rails_helper'

RSpec.describe DeleteSubscriptionService, type: :service do
  describe '.call' do
    let(:subscription_id) { 'subscription_id' }
    let(:stripe_subscription) { double('Subscription', id: subscription_id) }

    context 'when subscription exists and is paid' do
      it 'cancels the subscription' do
        paid_subscription = create(:subscription, stripe_id: subscription_id, state: 'paid')
        class_return = DeleteSubscriptionService.call(stripe_subscription)
        paid_subscription.reload
        expect(class_return).to be_truthy
        expect(paid_subscription).to be_canceled
      end
    end

    context 'does not attempt to cancel the subscription' do
      it 'when stripe subscription is not passed' do
        class_return = DeleteSubscriptionService.call(nil)
        expect(class_return).to be_nil
      end

      it 'when stripe subscription doesnt exist in our subscription table' do
        Subscription.find_by(stripe_id: subscription_id)&.destroy!
        class_return = DeleteSubscriptionService.call(stripe_subscription)
        expect(class_return).to be_nil
      end

      it 'when subscription exists but is not paid' do
        existing_subscription = create(:subscription, stripe_id: subscription_id, state: 'unpaid')
        class_return = DeleteSubscriptionService.call(stripe_subscription)
        expect(class_return).to be_nil
        existing_subscription.reload
        expect(existing_subscription).not_to be_canceled
      end
    end
  end
end
