# frozen_string_literal: true

class WebhooksController < ApplicationController
  # Handle incoming webhook events from Stripe
  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    event = verify_and_parse_event(payload, sig_header)
    return unless event

    handle_event(event)

    head :ok
  end

  private

  def verify_and_parse_event(payload, sig_header)
    StripeEventVerifier.new(payload, sig_header).verify_and_parse_event
  rescue JSON::ParserError, Stripe::SignatureVerificationError => e
    render_bad_request(e.message)
    nil
  end

  def render_bad_request(message)
    render status: :bad_request, json: { error: message }
  end

  private

  # Use factory to get the appropriate service based on event type
  def handle_event(event)
    service = ServiceFactory.new(event.type).create_service
    return unless service

    service.call(event.data.object)
  end
end
