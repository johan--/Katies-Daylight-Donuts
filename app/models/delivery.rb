class Delivery < ActiveRecord::Base
  acts_as_state_machine :initial => :pending
  state :pending
  state :delivered
  state :canceled
  
  event :deliver do
    transitions :from => :pending, :to => :delivered
  end
  
  event :undeliver do
    transitions :from => :delivered, :to => :pending
  end
  
  event :cancel do
    transitions :from => [:pending, :delivered], :to => :canceled
  end
  
  has_and_belongs_to_many :items
  belongs_to :location
  belongs_to :employee
  
  validates_presence_of :location, :employee
  
  named_scope :recent, :conditions => {:state => "delivered"}, :limit => 10, :order => "created_at"
  named_scope :pending, :conditions => {:state => "pending"}
  named_scope :delivered, :conditions => {:state => "delivered"}
  
  def delivery_time
    created_at.strftime("%m/%d/%Y")
  end
end
