class ServiceFactory
  def initialize(event_type)
    @event_type = event_type
  end

  def create_service
    case @event_type
    when 'customer.subscription.created'
      CreateSubscriptionService.new
    when 'invoice.payment_succeeded'
      InvoicePaymentSucceededService.new
    when 'customer.subscription.deleted'
      DeleteSubscriptionService.new
    else 
      nil
    end
  end
end
