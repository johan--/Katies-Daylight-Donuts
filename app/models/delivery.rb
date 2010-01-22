class Delivery < ActiveRecord::Base
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  has_many :buy_backs
  belongs_to :location, :include => [:customer]
  belongs_to :employee
  has_one :customer, :through => :location
  
  acts_as_mappable :through => :location
  
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
  
  
  validates_presence_of :location, :message => "Must be assigned a delivery location."
  validates_presence_of :employee, :message => "Must be assigned to an employee."
  
  named_scope :recent, :conditions => {:state => "delivered"}, :limit => 10, :order => "created_at ASC", :include => [:location,:employee]
  named_scope :pending, :conditions => {:state => "pending"}, :order => "created_at ASC", :include => [:location,:employee]
  named_scope :delivered, :conditions => {:state => "delivered"}, :order => "created_at ASC", :include => [:location,:employee]

  def delivery_time
    @delivery_time ||= created_at.strftime("%m/%d/%Y %H:%M:%S %p")
  end
  
  def customer_name
    @customer_name ||= location.customer.name rescue ""
  end
end
