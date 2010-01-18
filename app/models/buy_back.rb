class BuyBack < ActiveRecord::Base
  belongs_to :delivery
  
  acts_as_state_machine :initial => :pending
  state :pending
  state :paid
  state :voided
  
  event :pay do
    transitions :from => :pending, :to => :paid
  end
  
  event :void do
    transitions :from => :paid, :to => :pending
  end
end
