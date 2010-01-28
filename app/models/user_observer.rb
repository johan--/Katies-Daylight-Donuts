class UserObserver < ActiveRecord::Observer
  def before_update(user)
    
    # Deliver the forgotten password
    if user.perishable_token_changed?
      UserNotifier.deliver_password(user)
    end
    
  end
end
