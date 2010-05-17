class UserNotifier < ActionMailer::Base

  def message(recipients, message, time_period, payload)
    recipients   recipients
    from         "reports@katiesdaylightdonuts.com"
    body         message
    subject      "Sales Report for #{time_period}" 
    content_type "text/html"
    attachment :content_type => "text/plain", :body => payload, :filename => "importme.csv"
  end
  
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
  
  # User
  def signup_notification(recipients, user)
    recipients   recipients
    from         "noreply@katiesdaylightdonuts.com"
    body         :user => user
    subject      "Welcome to Katies Daylight Donuts, Online Ordering Service." 
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
  
  def password(user)
    recipients   user.email
    from         "noreply@katiesdaylightdonuts.com"
    body         :user => user
    subject      "Katies Daylight Donuts Forgot Password." 
    content_type "text/html"
  end
end
