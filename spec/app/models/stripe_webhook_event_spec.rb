# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeWebhookEvent, type: :model do
  describe 'Database schema' do
    it 'has a state column of type integer with default unpaid' do
      expect(ActiveRecord::Base.connection.column_exists?(:stripe_webhook_events, :state)).to eq(true)
      expect(Subscription.columns_hash['state'].type).to eq(:integer)
      expect(Subscription.columns_hash['state'].default).to eq('0')
    end
  end
end
