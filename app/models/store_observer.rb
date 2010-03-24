class StoreObserver < ActiveRecord::Observer
  
  def before_validation(store)
    unless store.email.blank?
      user = User.create_with_store(store) # emails the customer
      store.user = user 
    end
  end
  
  def after_create(store)
    store.delivery_presets.build_defaults
    store.save
  end
  
end
