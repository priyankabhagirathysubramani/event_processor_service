# frozen_string_literal: true

# DeleteSubscriptionService is a service object responsible for canceling a subscription
# in the database based on the provided stripe subscription object.
class DeleteSubscriptionService < ApplicationService
  # Initializes a new instance of the DeleteSubscriptionService.
  #
  # @param subscription [Object] The stripe subscription object containing subscription information.
  def initialize(subscription)
    @subscription = subscription
  end

  # Cancels the subscription record in the database if it exists and is paid.
  #
  # @return [nil]
  def call
    # Return early if the subscription object is not present
    return unless subscription.present?

    # Find the existing subscription record by its Stripe ID
    existing_subscription = Subscription.find_by(stripe_id: subscription.id)

    # Return early if no existing subscription is found or if it is not paid
    return unless existing_subscription.present? && existing_subscription.paid?

    # Cancel the existing subscription
    existing_subscription.canceled!
  end

  private

  attr_reader :subscription
end
