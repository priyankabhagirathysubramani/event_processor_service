# frozen_string_literal: true

class DeleteSubscriptionService < ApplicationService
  def initialize(subscription)
    @subscription = subscription
  end

  def call
    return unless subscription.present?

    existing_subscription = Subscription.find_by(stripe_id: subscription.id)
    return unless existing_subscription.present? && existing_subscription.paid?

    existing_subscription.canceled!
  end

  private

  attr_reader :subscription
end
