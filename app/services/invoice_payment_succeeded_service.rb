# frozen_string_literal: true

class InvoicePaymentSucceededService < ApplicationService
  def call(subscription)
    return unless subscription.present?

    begin
      Subscription.transaction do
        existing_subscription = Subscription.find_by(stripe_id: subscription)
        return unless existing_subscription

        existing_subscription.update!(state: :paid)
      end
    rescue StandardError => e
      "Error changing subscription state: #{e.message}"
    end
  end
end
