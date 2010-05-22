class Api::Sms < ActiveRecord::Base
  include AASM
  
  belongs_to :user
  
  aasm_column :state
  aasm_initial_state :recieved
  aasm_state :recieved
  aasm_state :replied
  aasm_state :delivered, :enter => :deliver_message
  
  aasm_event :replied_to do
    transitions :from => :recieved, :to => :replied_to
  end
  
  aasm_event :deliver do
    transitions :from => :recieved, :to => :delivered
  end

  private
  
  def deliver_message
    return true if self.user.username == "nobody"
    response = Zeep::Messaging.send_message(self.user.id, self.body)
    return response.all_good?
  end
  
end
