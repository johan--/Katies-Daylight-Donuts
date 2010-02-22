class CustomerMailer < ActionMailer::Base
  def welcome_email( customer )
    recipients customer.email
    from 'noreply@katiesdaylightdonuts.com'
    body :customer => customer
    subject "Welcome to Katies Daylight Donuts, Online Ordering System"
    content_type "text/html"
  end
end
