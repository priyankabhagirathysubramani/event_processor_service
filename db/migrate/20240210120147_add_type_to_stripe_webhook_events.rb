class AddTypeToStripeWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :stripe_webhook_events, :event_type, :string
  end
end
