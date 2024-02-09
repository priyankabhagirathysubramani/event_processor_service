require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'enums' do
    it 'defines the enum for state' do
      expect(Subscription).to have_db_column(:state).of_type(:integer).with_options(default: 'unpaid')
      expect(Subscription.states).to eq('unpaid' => 0, 'paid' => 1, 'canceled' => 2)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to allow_values(:unpaid, :paid, :canceled).for(:state) }
    it { is_expected.not_to allow_value(:invalid_state).for(:state) }
  end
end
