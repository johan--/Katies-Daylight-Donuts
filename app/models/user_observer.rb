class UserObserver < ActiveRecord::Observer
  def after_update(user)
    
  end
  
  # Send the user the invitation to setup their account.
  def after_create(user)
    UserNotifier.deliver_signup_notification(user.email, user)
  end
end
