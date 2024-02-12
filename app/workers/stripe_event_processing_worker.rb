# frozen_string_literal: true

# StripeEventProcessingWorker handles processing of incoming webhook events from Stripe.
# It parses the incoming payload, creates or finds the corresponding StripeWebhookEvent record,
# and delegates the event handling to an appropriate service based on the event type.
class StripeEventProcessingWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  queue_as :default

  # Perform method called by Sidekiq to process the webhook event.
  #
  # @param args [String] The JSON string representing the webhook event payload.
  def perform(args)
    # Convert the JSON string to a Ruby object and symbolize the keys
    stripe_event = Stripe::Util.convert_to_stripe_object(JSON.parse(args, symbolize_names: true))

    # Find or create a StripeWebhookEvent record based on the external ID and event type
    event = StripeWebhookEvent.find_by(external_id: stripe_event.request.idempotency_key,data: stripe_event.data, event_type: stripe_event.type)

    # Create a new StripeWebhookEvent if not found
    event ||= StripeWebhookEvent.create(external_id: stripe_event.request.idempotency_key, data: stripe_event.data, event_type: stripe_event.type)

    # Skip further processing if the event has already been processed
    return if event.processed?

    # Process the webhook event
    begin
      event.processing!
      # Call the appropriate event handler service based on the event type
      service = EventHandlers::Factory.call(stripe_event.type)
      service.call(stripe_event.data.object)
      event.processed!
    rescue StandardError => e
      # Update the event state to 'failed' and store the processing error message
      event.update(state: :failed, processing_errors: e.message)
      Rails.logger.error("Error processing webhook event: #{e.message}")
    end
  end
end
