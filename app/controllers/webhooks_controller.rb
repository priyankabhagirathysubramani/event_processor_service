# frozen_string_literal: true

class WebhooksController < ApplicationController
  rescue_from JSON::ParserError, Stripe::SignatureVerificationError, with: :render_bad_request
  # Handle incoming webhook events from Stripe
  def stripe
    handle_event

    head :ok
  end

  private

  attr_reader :event

  def event
    @event ||= StripeEventVerifier.call(request.body.read, sig_header)
  end

  def sig_header
    request.env['HTTP_STRIPE_SIGNATURE']
  end

  # Use factory to get the appropriate service based on event type
  def handle_event
    service = EventHandlers::Factory.call(event.type)
    return unless service

    service.call(event.data.object)
  end

  def render_bad_request(exception)
    render status: :bad_request, json: { error: exception.message }
  end
end
