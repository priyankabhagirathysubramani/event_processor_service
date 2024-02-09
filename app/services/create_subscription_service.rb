# frozen_string_literal: true

class CreateSubscriptionService < ApplicationService
  def call(subscription)
    return unless subscription && subscription.id.present?

    begin
      Subscription.transaction do
        existing_subscription = Subscription.find_by(stripe_id: subscription.id)
        return if existing_subscription

        Subscription.create!(stripe_id: subscription.id)
      end
    rescue StandardError => e
      "Error creating subscription record: #{e.message}"
    end
  end
end
