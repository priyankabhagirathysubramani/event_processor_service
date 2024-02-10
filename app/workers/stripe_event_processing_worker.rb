# frozen_string_literal: true

class StripeEventProcessingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  queue_as :default

  def perform(args)
    stripe_event = Stripe::Util.convert_to_stripe_object(JSON.parse(args, symbolize_names: true))

    service = EventHandlers::Factory.call(stripe_event.type)
    return unless service

    event = StripeWebhookEvent.find_by(external_id: stripe_event.request.idempotency_key, event_type: stripe_event.type, data: stripe_event.data)

    # Create a new WebhookEvent if not found
    event ||= StripeWebhookEvent.create(external_id: stripe_event.request.idempotency_key, data: stripe_event.data, event_type: stripe_event.type)
    return if event.processed?


    begin
      event.processing!
      service.call(stripe_event.data.object)
      event.processed!
    rescue StandardError => e
      event.update(state: :failed, processing_errors: e.message)
      Rails.logger.error("Error processing webhook event: #{e.message}")
    end
  end
end
