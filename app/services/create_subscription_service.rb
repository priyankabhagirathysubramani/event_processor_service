# frozen_string_literal: true

# CreateSubscriptionService is a service object responsible for creating a subscription record
# in the database based on the provided stripe subscription object.
class CreateSubscriptionService < ApplicationService
  # Initializes a new instance of the CreateSubscriptionService.
  #
  # @param subscription [Object] The stripe subscription object containing subscription information.
  def initialize(subscription)
    @subscription = subscription
  end

  # Creates a new subscription record in the database if it does not already exist.
  #
  # @return [nil]
  def call
    # Return early if the subscription object or its ID is not present
    return unless subscription && subscription.id.present?

    # Check if a subscription with the provided Stripe ID already exists
    existing_subscription = Subscription.find_by(stripe_id: subscription.id)

    # Return early if the subscription already exists
    return if existing_subscription

    # Create a new subscription record with the provided Stripe ID
    Subscription.create!(stripe_id: subscription.id)
  end

  private

  attr_reader :subscription
end
