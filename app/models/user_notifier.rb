class UserNotifier < ActionMailer::Base
  
  # Delivery
  def new_delivery_notification(recipients, delivery)
    recipients   recipients
    from         "noreply@katiesdaylightdonuts.com"
    body         :delivery => delivery
    subject      "New Delivery" 
    content_type "text/html"
  end
  
  # Delivery
  def delivered_notification(recipients, delivery)
    recipients   recipients
    from         "noreply@katiesdaylightdonuts.com"
    body         :delivery => delivery
    subject      "Delivery delivered" 
    content_type "text/html"
  end
  
  # Employee
  def new_employee_notification(recipients, employee)
    recipients   recipients
    from         "noreply@katiesdaylightdonuts.com"
    body         :employee => employee
    subject      "New Employee" 
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
