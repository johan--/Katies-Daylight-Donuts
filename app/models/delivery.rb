class Delivery < ActiveRecord::Base
  include AASM
  
  attr_accessor :store_name
  
  has_many :comments, :as => :commentable
  
  has_many :line_items, :dependent => :destroy
  has_many :items, :through => :line_items
  
  has_many :buy_backs, :dependent => :destroy
  belongs_to :employee
  belongs_to :store
  
  aasm_column :state
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :printed
  aasm_state :delivered
  aasm_state :canceled
  
  aasm_event :print do
    transitions :from => [:delivered,:canceled,:printed,:pending], :to => :printed
  end
  
  aasm_event :deliver do
    transitions :from => [:printed,:pending,:canceled], :to => :delivered, :guard => :record_delivery_time
  end
  
  aasm_event :undeliver do
    transitions :from => [:delivered,:printed], :to => :pending
  end
  
  aasm_event :cancel do
    transitions :from => [:pending, :delivered, :printed], :to => :canceled
  end
  
  
  validates_presence_of :store, :message => "Must be assigned a store location."
  validates_presence_of :employee_id, :message => "Driver required."
  validates_presence_of :delivery_date, :message => "Must have a date to be delivered." 
  
  named_scope :recent, :conditions => {:state => "delivered"}, :limit => 10, :order => "delivery_date ASC", :include => [:store,:employee]
  named_scope :pending, :conditions => {:state => "pending"}, :order => "delivery_date ASC", :include => [:store,:employee]
  named_scope :delivered, :conditions => {:state => "delivered"}, :order => "delivery_date ASC", :include => [:store,:line_items]
  # This does not work with postgresql db's for some reason
  named_scope :delivered_this_week, :conditions => {:state => "delivered", :delivered_at => "between #{Time.now.at_beginning_of_week.to_s(:db)} and #{Time.now.at_end_of_week.to_s(:db)}"}
  named_scope :by_date, lambda { |*args|
    args[0] ||= Time.zone.now
    {
      :order => "delivery_date asc",
      :conditions => ["delivery_date BETWEEN ? AND ?", args[0].beginning_of_day.to_s(:db), (args[1]||args[0]).end_of_day.to_s(:db)]
    }
  }
  named_scope :printed, :conditions => {:state => "printed"}
  named_scope :unprinted, :conditions => "deliveries.state = 'pending' or deliveries.state = 'delivered'"
  named_scope :unpaid, :conditions => {:paid => false}
  named_scope :paid, :conditions => {:paid => true}
  
  def self.metric_chart
    months,counts = [],[]
    all.group_by{|d| d.delivery_date.to_date }.map{|month,d| 
      if d.first.delivery_date.to_date.year == Time.zone.now.year
        months << month.strftime("%h %Y").upcase
        counts << (d.map(&:total).sum/100).to_i
      end
  }
  "http://chart.apis.google.com/chart?chxt=Sales&cht=lc&chf=c,ls,0,CCCCCC,0.05,FFFFFF,0.05&chco=5D85BF&chd=t:#{counts.join(',')}&chs=430x100&chl=#{months.uniq.join('|')}"
  end
  
  def donut_count
    self.line_items.map{|i| i.quantity if i.donut? }.compact.sum
  end
  
  def roll_count
    self.line_items.map{|i| i.quantity if i.roll? }.compact.sum
  end
  
  def donut_hole_count
    self.line_items.map{|i| i.quantity if i.donut_hole? }.compact.sum
  end
  
  def delivery_option
    "#{store.name} - ##{id} - #{delivery_time}"
  end
  
  def description
    line_items.map{|line_item| "#{line_item.item.name} #{line_item.quantity}"}.join(", ")
  end

  def email
    (store.nil? || store.user.nil?) ? "" : store.user.email
  end

  def address
    "#{store.name} ##{id} - #{store.to_google}"
  end

  def delivery_time
    @delivery_time ||= delivery_date.strftime("%m/%d/%Y %H:%M:%S %p")
  end
  
  def customer_name
    @customer_name ||= store.name rescue ""
  end
  
  def total
    line_items.collect{ |i| i.quantity.to_i * i.price.to_f }.sum || 0
  end
  
  def update_line_items(*args)
    args.first.each do |line_item|
      item = Item.find(line_item[:item_id])
      if existing_line_item = self.line_items.detect{ |l| l.item_id == item.id.to_i }
        existing_line_item.quantity = line_item[:quantity]
        existing_line_item.price    = line_item[:price]
        existing_line_item.save!
      elsif line_item[:quantity].to_i > 0
        self.line_items.create(:item => item, :quantity => line_item[:quantity], :price => line_item[:price])
      end
    end
  end
  
  # Used to add all available items to a delivery
  # This is called in the deliveries controller new action
  def add_items
    Item.available.each{ |item| add_item(item, 12) }
  end
  
  # Adds a single item to the delivery
  def add_item(item, quantity)
    raise Exception, "Quantity required!" unless quantity.to_i > 0
    options = {
      :quantity => quantity.to_i,
      :item => item,
      :price => item.price.to_f
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
