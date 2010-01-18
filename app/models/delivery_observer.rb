class DeliveryObserver < ActiveRecord::Observer

  def after_create(delivery)
    # Notify a new delivery was created 
    UserNotifier.deliver_new_delivery_notification(Setting.email, delivery)
    return true
  end
  
  def after_update(delivery)
    if delivery.delivered?
      # delivery.delivered_at = Time.now
      
      # Notify of deliveries
      UserNotifier.deliver_delivered_notification(Setting.email, delivery) 
    end
  end
  
  def logger
    RAILS_DEFAULT_LOGGER
  end
end
