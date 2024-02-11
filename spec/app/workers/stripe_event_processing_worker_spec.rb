# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventProcessingWorker, type: :worker do
  describe '#perform' do
    let(:worker) { StripeEventProcessingWorker.new }
    let(:stripe_event) { double('Stripe::Event', type: 'invoice.payment_succeeded', request: double('Request', idempotency_key: 'idempotency_key'), data: double('Data', object: {})) }
    let(:service) { double('Service', call: nil) }
    let(:event) { instance_double('StripeWebhookEvent', processed?: false, processing!: nil, processed!: nil, update: nil) }

    before do
      allow(JSON).to receive(:parse).and_return(stripe_event)
      allow(Stripe::Util).to receive(:convert_to_stripe_object).and_return(stripe_event)
      allow(EventHandlers::Factory).to receive(:call).and_return(service)
      allow(StripeWebhookEvent).to receive(:find_by).and_return(nil)
      allow(StripeWebhookEvent).to receive(:create).and_return(event)
    end

    it 'creates a new StripeWebhookEvent if not found' do
      expect(StripeWebhookEvent).to receive(:create).with(external_id: 'idempotency_key', data: {}, event_type: 'invoice.payment_succeeded')
      worker.perform('{}')
    end

    it 'does not create a new StripeWebhookEvent if found' do
      allow(StripeWebhookEvent).to receive(:find_by).and_return(event)
      expect(StripeWebhookEvent).not_to receive(:create)
      worker.perform('{}')
    end

    it 'processes the event' do
      expect(service).to receive(:call).with({})
      worker.perform('{}')
    end

    it 'updates the event to processed if successful' do
      expect(event).to receive(:processed!)
      worker.perform('{}')
    end

    it 'updates the event to failed if an error occurs' do
      allow(service).to receive(:call).and_raise(StandardError, 'Something went wrong')
      expect(event).to receive(:update).with(state: :failed, processing_errors: 'Something went wrong')
      worker.perform('{}')
    end
  end
end
