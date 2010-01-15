class UserNotifier < ActionMailer::Base
  def new_delivery_notification(recipients, delivery)
    recipients   recipients
    from         "noreply@katiesdonuts.com"
    body         :delivery => delivery
    subject      "New Delivery" 
    content_type "text/html"
  end
end
