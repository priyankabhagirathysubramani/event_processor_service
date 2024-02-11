# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  describe 'POST #stripe' do
    let(:event_data) { { id: 'evt_123', type: 'payment_intent.succeeded', data: { object: { id: 'pi_123' } } } }
    let(:valid_signature) { 'valid_signature' }
    let(:invalid_signature) { 'invalid_signature' }
    let(:request_body) { event_data.to_json }
    let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => valid_signature } }

    before do
      allow(StripeEventVerifier).to receive(:call).and_return(event_data)
    end

    context 'when signature is valid' do
      it 'enqueues event processing in the background' do
        expect(StripeEventProcessingWorker).to receive(:perform_async).with(event_data.to_json)
        post :stripe, body: request_body
      end

      it 'responds with 200 OK' do
        post :stripe, body: request_body
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when signature is invalid' do
      let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => invalid_signature } }

      it 'does not enqueue event processing' do
        expect(StripeEventProcessingWorker).not_to receive(:perform_async)
        post :stripe, body: request_body
      end

      it 'responds with 400 Bad Request' do
        post :stripe, body: request_body
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when JSON::ParserError occurs' do
      before do
        allow(StripeEventVerifier).to receive(:call).and_raise(JSON::ParserError)
      end

      it 'responds with 400 Bad Request' do
        post :stripe, body: request_body
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'when Stripe::SignatureVerificationError occurs' do
      before do
        allow(StripeEventVerifier).to receive(:call).and_raise(Stripe::SignatureVerificationError)
      end

      it 'responds with 400 Bad Request' do
        post :stripe, body: request_body
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
