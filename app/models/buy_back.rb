class BuyBack < ActiveRecord::Base  
  include AASM
  
  belongs_to :delivery
  
  aasm_initial_state :pending
  
  aasm_column :state
  
  aasm_state :pending
  aasm_state :paid
  aasm_state :voided
  
  aasm_event :pay do
    transitions :from => :pending, :to => :paid
  end
  
  aasm_event :void do
    transitions :from => :paid, :to => :pending
  end
end
