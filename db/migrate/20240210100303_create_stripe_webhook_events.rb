class CreateStripeWebhookEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :stripe_webhook_events do |t|
      t.json :data
      t.integer :state, default: 0
      t.string :external_id
      t.string :processing_errors

      t.timestamps
    end
  end
end
