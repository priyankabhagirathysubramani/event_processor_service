# frozen_string_literal: true

require 'rails_helper'
require_relative '../../helpers/stripe_test_helper'

RSpec.describe 'WebhooksRequest', type: :request do
  include StripeTestHelper
  describe 'POST /webhooks/stripe' do
    let(:event_data) { StripeMock.mock_webhook_event('customer.subscription.created') }
    let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => stripe_event_signature(event_data.to_json) } }

    context 'when signature is valid' do
      it 'enqueues event processing in the background' do
        expect(StripeEventProcessingWorker).to receive(:perform_async)
        post webhooks_stripe_path, params: event_data.to_json, headers: headers
        expect(response).to have_http_status(:accepted)
      end
    end

    context 'when Json passed is invalid' do
      it 'responds with 400 Bad Request' do
        post webhooks_stripe_path, params: '{', headers: headers
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when Signature passed is invalid' do
      it 'responds with 400 Bad Request' do
        headers['HTTP_STRIPE_SIGNATURE'] = 'invalid_signature'
        post webhooks_stripe_path, params: event_data.to_json, headers: headers
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
