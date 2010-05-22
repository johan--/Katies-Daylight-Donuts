module Admin::SmsHelper
  def display_sms_message(message)
    content_tag(:span){ message.user.username } +
    content_tag(:span){ message.user.mobile_number } +
    " : " +
    content_tag(:span){ message.body }
  end
end
