# frozen_string_literal: true

class InvoicePaymentSucceededService < ApplicationService
  def initialize(invoice)
    @subscription = invoice.subscription
  end

  def call
    return unless subscription.present?

    existing_subscription = Subscription.find_by(stripe_id: subscription)
    return unless existing_subscription

    existing_subscription.paid!
  end

  private

  attr_reader :subscription
end
