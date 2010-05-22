class Api::Sms < ActiveRecord::Base
  include AASM
  
  belongs_to :user
  
  aasm_column :state
  aasm_initial_state :unread
  aasm_state :unread
  aasm_state :read
  aasm_state :delivered, :enter => :deliver_message
  
  aasm_event :to_read do
    transitions :from => :unread, :to => :read
  end
  
  aasm_event :to_unread do
    transitions :from => :read, :to => :unread
  end
  
  def ticker_string
    "#{self.created_at.strftime('%b, %d %I:%M %p')} From: #{self.user.store_name_or_mobile}, #{self.body}"
  end
  
  private
  
  def deliver_message
    return true if self.user.username == "nobody"
    response = Zeep::Messaging.send_message(self.user.id, self.body)
    return response.all_good?
  end
  
end
