class UserNotifier < ActionMailer::Base
  def new_delivery_notification(recipients, delivery)
    recipients   recipients
    from         "noreply@katiesdaylightdonuts.com"
    body         :delivery => delivery
    subject      "New Delivery" 
    content_type "text/html"
  end
  
  def delivered_notification(recipients, delivery)
    recipients   recipients
    from         "noreply@katiesdaylightdonuts.com"
    body         :delivery => delivery
    subject      "Delivery delivered" 
    content_type "text/html"
  end
  
  def password(user, password)
    recipients   user.email
    from         "noreply@katiesdaylightdonuts.com"
    body         :user => user
    subject      "Katies Daylight Donuts Forgot Password." 
    content_type "text/html"
  end
end
