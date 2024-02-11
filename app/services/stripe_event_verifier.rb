# frozen_string_literal: true

# StripeEventVerifier is a service object responsible for verifying the authenticity
# of incoming Stripe webhook events.
class  StripeEventVerifier < ApplicationService
  # Initializes a new instance of the StripeEventVerifier.
  #
  # @param payload [String] The payload of the incoming webhook event.
  # @param sig_header [String] The signature header of the incoming webhook event.
  def initialize(payload, sig_header)
    @payload = payload
    @sig_header = sig_header
  end

  # Verifies the authenticity of the incoming webhook event using the Stripe SDK.
  #
  # @return [Object] The verified Stripe event object.
  def call
    # Construct and return the verified Stripe event using the Stripe SDK
    Stripe::Webhook.construct_event(
      @payload,
      @sig_header,
      Rails.application.credentials.stripe.webhook_secret
    )
  end
end
