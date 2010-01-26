class Delivery < ActiveRecord::Base
  include AASM
  
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  has_many :buy_backs
  belongs_to :location, :include => [:customer]
  belongs_to :employee
  has_one :customer, :through => :location
  
  acts_as_mappable :through => :location
  
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :delivered
  aasm_state :canceled
  
  aasm_event :deliver do
    transitions :from => :pending, :to => :delivered
  end
  
  aasm_event :undeliver do
    transitions :from => :delivered, :to => :pending
  end
  
  aasm_event :cancel do
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
  
  def total
    items.map(&:price).to_a.sum
  end
  
  def add_item(item, quantity)
    raise Exception, "Quantity required!" unless quantity.to_i > 0
    options = {
      :quantity => quantity.to_i,
      :item => item,
      :price => (quantity.to_i * item.price.to_f)
    }
    if self.new_record?
      line_item = line_items.build(options)
    else
      line_item = line_items.create(options)
    end
    line_item
  end
  
  def remove_item(item)
    if line_item = link_items.detect{ |li| li.item_id == item.id }
      line_items -= line_item
    end
  end
end
