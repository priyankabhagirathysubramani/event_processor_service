class StripeEventVerifier
  def initialize(payload, sig_header)
    @payload = payload
    @sig_header = sig_header
  end

  def verify_and_parse_event
    Stripe::Webhook.construct_event(@payload, @sig_header, Rails.application.credentials.stripe.webhook_secret)
  end
end
