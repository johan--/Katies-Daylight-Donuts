class UserObserver < ActiveRecord::Observer
  def after_update(user)
    
  end
  
  # Send the user the invitation to setup their account.
  def after_create(user)
    user.reset_perishable_token! # set the perishable token to some value
    UserNotifier.deliver_signup_notification(user.email, user)
  end
end
