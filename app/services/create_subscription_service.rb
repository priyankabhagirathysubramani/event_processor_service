# frozen_string_literal: true

class CreateSubscriptionService < ApplicationService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    return unless subscription && subscription.id.present?

    existing_subscription = Subscription.find_by(stripe_id: subscription.id)
    return if existing_subscription

    Subscription.create!(stripe_id: subscription.id)
  end

  private

  attr_reader :subscription
end
