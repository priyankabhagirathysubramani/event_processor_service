# frozen_string_literal: true

class WebhooksController < ApplicationController
  rescue_from JSON::ParserError, Stripe::SignatureVerificationError, with: :render_bad_request

  # Handle incoming webhook events from Stripe
  def stripe
    enqueue_event_processing

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

  # Do the processing in bg
  def enqueue_event_processing
    StripeEventProcessingWorker.perform_async(event.to_json)
  end

  def render_bad_request(exception)
    render status: :bad_request, json: { error: exception.message }
  end
end
