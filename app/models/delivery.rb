class Delivery < ActiveRecord::Base
  include AASM
  
  has_many :comments, :as => :commentable
  
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  has_many :buy_backs
  belongs_to :employee
  belongs_to :store
  
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :delivered
  aasm_state :canceled
  
  aasm_event :deliver do
    transitions :from => :pending, :to => :delivered, :guard => :record_delivery_time
  end
  
  aasm_event :undeliver do
    transitions :from => :delivered, :to => :pending
  end
  
  aasm_event :cancel do
    transitions :from => [:pending, :delivered], :to => :canceled
  end
  
  
  validates_presence_of :store, :message => "Must be assigned a store location."
  validates_presence_of :employee, :message => "Driver required."
  
  named_scope :recent, :conditions => {:state => "delivered"}, :limit => 10, :order => "created_at ASC", :include => [:store,:employee]
  named_scope :pending, :conditions => {:state => "pending"}, :order => "created_at ASC", :include => [:store,:employee]
  named_scope :delivered, :conditions => {:state => "delivered"}, :order => "created_at ASC", :include => [:store,:employee]

  def self.create_default_delivery(options = {})
    delivery = self.new
    delivery.add_items
    delivery.employee = Employee.default
    delivery.save!
  end

  def address
    "#{store.name} ##{id} - #{store.to_google}"
  end

  def delivery_time
    @delivery_time ||= created_at.strftime("%m/%d/%Y %H:%M:%S %p")
  end
  
  def customer_name
    @customer_name ||= store.name rescue ""
  end
  
  def total
    line_items.collect{ |i| i.quantity.to_i * i.price }.sum
  end
  
  def update_line_items(*args)
    args.first.each do |line_item|
      if existing_line_item = self.line_items.detect{ |l| l.item_id == line_item[:item_id].to_i }
        existing_line_item.quantity = line_item[:quantity]
        existing_line_item.price    = line_item[:price]
        existing_line_item.save!
      end
    end
  end
  
  def add_items
    Item.available.each{ |item| add_item(item, 12) }
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
  
  private
  
  def record_delivery_time
    self.delivered_at = Time.now.utc
  end
end
