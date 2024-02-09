class UpdateState < ActiveRecord::Migration[7.0]
  def change
    change_table :subscriptions do |t|
      t.change :state, :integer, default: 0
    end
  end
end
