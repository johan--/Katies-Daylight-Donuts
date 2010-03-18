class StoreObserver < ActiveRecord::Observer
  
  def after_create(store)
    user = User.create_with_store(store) # emails the customer
    store.user = user 
    store.delivery_presets.build_defaults
    store.save
  end
  
end
