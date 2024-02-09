# frozen_string_literal: true

class DeleteSubscriptionService < ApplicationService
  def call(subscription)
    return unless subscription.present?

    begin
      Subscription.transaction do
        existing_subscription = Subscription.find_by(stripe_id: subscription.id)
        return unless existing_subscription.present? && existing_subscription.state == 'paid'

        existing_subscription.update!(state: :canceled)
      end
    rescue StandardError => e
      "Error deleting subscription record: #{e.message}"
    end
  end
end
