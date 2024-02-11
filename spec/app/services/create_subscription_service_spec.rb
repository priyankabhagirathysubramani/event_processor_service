require 'rails_helper'

RSpec.describe CreateSubscriptionService, type: :service do
  describe '.call' do
    let(:subscription_id) { "sub_#{SecureRandom.hex(14)}" }
    let(:stripe_subscription) { double('Subscription', id: subscription_id) }

    context 'when subscription does not exist' do
      it 'creates a new subscription with unpaid state' do
        class_return = CreateSubscriptionService.call(stripe_subscription)
        new_subscription = Subscription.find_by(stripe_id: subscription_id)
        expect(new_subscription).not_to be_nil
        expect(new_subscription).to be_unpaid
        expect(class_return).to be_truthy
      end
    end

    context 'when subscription already exists' do
      it 'does not create a new subscription' do
        existing_subscription = create(:subscription)
        subscription_size = Subscription.all.size
        stripe_subscription_with_existing_id = double('Subscription', id: existing_subscription.stripe_id)
        class_return = CreateSubscriptionService.call(stripe_subscription_with_existing_id)
        expect(Subscription.all.size).to eq(subscription_size)
        expect(class_return).to be_nil
      end
    end

    context 'when stripe subscription is not passed' do
      it 'does nothing and returns' do
        class_return = CreateSubscriptionService.call(nil)
        expect(class_return).to be_nil
      end
    end

    context 'when stripe subscription is passed does not have an id' do
      it 'does nothing and returns' do
        class_return = CreateSubscriptionService.call(double('Subscription', id: nil))
        expect(class_return).to be_nil
      end
    end
  end
end
