class StoreObserver < ActiveRecord::Observer
  
  def after_create(store)
    unless store.email.nil?
      user = User.create_with_store(store) # emails the customer
      store.user = user 
    end
    store.delivery_presets.build_defaults
    store.save
  end
  
end
