class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :stripe_id
      t.string :state

      t.timestamps
    end
  end
end
