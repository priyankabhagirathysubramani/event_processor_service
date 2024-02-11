# frozen_string_literal: true

require 'rails_helper'
require_relative '../../helpers/stripe_test_helper'

RSpec.describe StripeEventVerifier, type: :service do
  include StripeTestHelper
  describe '#call' do
    let(:payload) { StripeMock.mock_webhook_event('invoice.payment_succeeded') }

    it 'constructs and verifies the Stripe webhook event' do
      verifier = StripeEventVerifier.call(payload.to_json, stripe_event_signature(payload.to_json))
      expect(verifier).not_to be_nil
    end

    it 'throws error when invalid signature is passed' do
      expect { StripeEventVerifier.call(payload, 'invalid_secret') }.to raise_error(Stripe::SignatureVerificationError)
    end
  end
end

