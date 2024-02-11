module StripeTestHelper
  def stripe_event_signature(payload)
    time = Time.now
    secret = Rails.application.credentials.stripe.webhook_secret
    signature = Stripe::Webhook::Signature.compute_signature(time, payload, secret)
    Stripe::Webhook::Signature.generate_header(
      time,
      signature,
      scheme: Stripe::Webhook::Signature::EXPECTED_SCHEME
    )
  end
end
