# frozen_string_literal: true

class StripeEventProcessingWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  queue_as :default

  def perform(args)
    stripe_event = Stripe::Util.convert_to_stripe_object(JSON.parse(args, symbolize_names: true))

    event = StripeWebhookEvent.find_by(external_id: stripe_event.request.idempotency_key, event_type: stripe_event.type)

    # Create a new StripeWebhookEvent if not found
    event ||= StripeWebhookEvent.create(external_id: stripe_event.request.idempotency_key, data: stripe_event.data, event_type: stripe_event.type)
    return if event.processed?


    begin
      event.processing!
      service = EventHandlers::Factory.call(stripe_event.type)
      service.call(stripe_event.data.object)
      event.processed!
    rescue StandardError => e
      event.update(state: :failed, processing_errors: e.message)
      Rails.logger.error("Error processing webhook event: #{e.message}")
    end
  end
end
