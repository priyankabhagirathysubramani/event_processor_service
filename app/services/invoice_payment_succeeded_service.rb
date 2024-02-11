# frozen_string_literal: true

# InvoicePaymentSucceededService is a service object responsible for updating
# the status of corresponding subscription to 'paid' when an invoice payment is succeeded.
class InvoicePaymentSucceededService < ApplicationService
  # Initializes a new instance of the InvoicePaymentSucceededService.
  #
  # @param invoice [Object] The stripe invoice object representing the payment that succeeded.
  def initialize(invoice)
    @subscription = invoice&.subscription
  end

  # Updates the status of the subscription to 'paid' if it exists.
  #
  # @return [nil]
  def call
    # Return early if the subscription object is not present
    return unless subscription.present?

    # Find the existing subscription record by its Stripe ID
    existing_subscription = Subscription.find_by(stripe_id: subscription)

    # Return early if no existing subscription is found
    return unless existing_subscription

    # Update the status of the existing subscription to 'paid'
    existing_subscription.paid!
  end

  private

  attr_reader :subscription
end
