# frozen_string_literal: true

require 'rails_helper'
require_relative '../../helpers/stripe_test_helper'

RSpec.describe StripeEventProcessingWorker, type: :worker do
  include StripeTestHelper
  describe '#perform' do
    let(:worker) { StripeEventProcessingWorker.new }
    let(:stripe_webhook_event) { create(:stripe_webhook_event) }
    let(:stripe_subscription_event) { StripeMock.mock_webhook_event('customer.subscription.created') }

    it 'creates a new StripeWebhookEvent if not found' do
      size_before_perform = StripeWebhookEvent.all.size
      worker.perform(stripe_subscription_event.to_json)
      logged_event_in_db = StripeWebhookEvent.find_by(external_id: stripe_subscription_event.request.idempotency_key)
      expect(logged_event_in_db).not_to be_nil
      expect(StripeWebhookEvent.all.size).to eq(size_before_perform+1)
      expect(logged_event_in_db).to be_processed
    end

    it 'does not create a new StripeWebhookEvent if found' do
      exisisting_stripe_webhook_event = create(:stripe_webhook_event, external_id: stripe_subscription_event.request.idempotency_key, event_type: stripe_subscription_event.type, data: stripe_subscription_event.data )
      size_before_perform = StripeWebhookEvent.all.size
      worker.perform(stripe_subscription_event.to_json)
      expect(StripeWebhookEvent.all.size).to eq(size_before_perform)
    end
  end
end
