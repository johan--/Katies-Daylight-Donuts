class DeliveryObserver < ActiveRecord::Observer

  def after_create(delivery)
    UserNotifier.deliver_new_delivery_notification("me@timmatheson.com", delivery)
    return true
  end
  
  def logger
    RAILS_DEFAULT_LOGGER
  end
end
