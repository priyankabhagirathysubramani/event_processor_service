# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventVerifier, type: :service do
  describe '#call' do
    let(:payload) { 'payload_data' }
    let(:invalid_secret) { SecureRandom.hex(8) }
    let(:event) { double('Event') }

    it 'constructs and verifies the Stripe webhook event' do
      verifier = StripeEventVerifier.call(payload, generate_stripe_event_signature(payload))
      expect(verifier).not_to be_nil
    end

    it 'throws error when invalid signature is passed' do
      expect { StripeEventVerifier.call(payload, invalid_secret) }.to raise_error(Stripe::SignatureVerificationError)
    end

    it 'throws error when invalid json payload is passed' do
      expect { StripeEventVerifier.call(nil, invalid_secret) }.to raise_error(Stripe::SignatureVerificationError)
    end
  end

  def generate_stripe_event_signature(payload)
    time = Time.now
    secret = Rails.application.credentials.stripe[:signing_secret]
    signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
    Stripe::Webhook::Signature.generate_header(
      time,
      signature,
      scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
    )
  end
end

