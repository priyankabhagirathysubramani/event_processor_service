# frozen_string_literal: true

class WebhooksController < ApplicationController
  # The WebhooksController handles incoming webhook events from Stripe.
  # It includes methods to verify and process the events asynchronously.

  # Rescues from JSON::ParserError and Stripe::SignatureVerificationError and renders a bad request response.
  rescue_from JSON::ParserError, Stripe::SignatureVerificationError, with: :render_bad_request

  # Handles incoming webhook events from Stripe.
  def stripe
    enqueue_event_processing if supported_event?
    head :accepted
  end

  private

  # Reads the request body and verifies the Stripe event.
  def event
    @event ||= StripeEventVerifier.call(request.body.read, sig_header)
  end

  # Retrieves the Stripe signature header from the request environment.
  def sig_header
    request.env['HTTP_STRIPE_SIGNATURE']
  end

  # Enqueues the event processing job if the event is supported.
  def enqueue_event_processing
    StripeEventProcessingWorker.perform_async(event.to_json)
  end

  # Renders a bad request response.
  def render_bad_request(exception)
    render status: :bad_request, json: { error: exception.message }
  end

  # Checks if the event type is supported.
  def supported_event?
    STRIPE_EVENTS.include?(event.type)
  end
end
