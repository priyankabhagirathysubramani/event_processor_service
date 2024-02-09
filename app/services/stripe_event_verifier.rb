# frozen_string_literal: true

class StripeEventVerifier < ApplicationService
  def initialize(payload, sig_header)
    @payload = payload
    @sig_header = sig_header
  end

  def call
    Stripe::Webhook.construct_event(@payload, @sig_header, Rails.application.credentials.stripe.webhook_secret)
  end
end
