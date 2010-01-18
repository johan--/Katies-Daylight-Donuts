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
  has_many :buy_backs
  belongs_to :location
  belongs_to :employee
  
  validates_presence_of :location, :message => "Must be assigned a delivery location."
  validates_presence_of :employee, :message => "Must be assigned to an employee."
  
  named_scope :recent, :conditions => {:state => "delivered"}, :limit => 10, :order => "created_at ASC", :include => [:location]
  named_scope :pending, :conditions => {:state => "pending"}, :order => "created_at ASC", :include => [:location]
  named_scope :delivered, :conditions => {:state => "delivered"}, :order => "created_at ASC", :include => [:location]
  
  def delivery_time
    @delivery_time ||= created_at.strftime("%m/%d/%Y %H:%M:%S %p")
  end
  
  def customer_name
    @customer_name ||= location.customer.name
  end
end
