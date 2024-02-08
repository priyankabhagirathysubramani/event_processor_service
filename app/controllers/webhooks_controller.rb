# frozen_string_literal: true

class WebhooksController < ApplicationController
  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, Rails.application.credentials.stripe.webhook_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      render status: :bad_request, json: { error: e.message }
      return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      render status: :bad_request, json: { error: e.message }
      return
    end

    # Handle the event
    case event.type
    when 'customer.subscription.created'
      handle_subscription_created(event.data.object)
    when 'invoice.payment_succeeded'
      handle_invoice_payment_succeeded(event.data.object)
    when 'customer.subscription.deleted'
      handle_subscription_deleted(event.data.object)
    end

    head :ok
  end

  private

  def handle_subscription_created(subscription)
    Subscription.create(stripe_id: subscription.id, state: 'unpaid')
  end

  def handle_invoice_payment_succeeded(invoice)
    subscription = Subscription.find_by(stripe_id: invoice.subscription)
    subscription.update(state: 'paid') if subscription.present?
  end

  def handle_subscription_deleted(subscription)
    subscription_record = Subscription.find_by(stripe_id: subscription.id)
    unless subscription_record.present? && subscription.status == 'canceled' && subscription_record.state == 'paid'
      return
    end

    subscription_record.update(state: 'canceled')
  end
end
