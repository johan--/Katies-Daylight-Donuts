class BuyBack < ActiveRecord::Base  
  include AASM
  
  belongs_to :delivery, :dependent => :destroy
  has_many :line_items
  
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
  
  def copy_delivery_line_items
    return if self.delivery.nil? || self.delivery.line_items.empty?
    delivery.line_items.each do |line_item|
      if existing_item = self.line_items.detect{ |item| item if item.item_id == line_item.item_id }
        existing_item.quantity = line_item.quantity
        existing_item.price = line_item.price
      else
        line_items.build(:item_id => line_item.item.id, :quantity => line_item.quantity, :price => line_item.price)
      end
    end
    self.line_items
  end
  
  def copy_delivery_line_items!
    copy_delivery_line_items
    save
  end

  def copy_attributes
    unless self.delivery.nil?
      self.donuthole_count = line_items.collect{|line_item| line_item.quantity if line_item.item.name =~ /donuthole/i }.compact.sum
      self.roll_count = line_items.collect{|line_item| line_item.quantity if line_item.item.name =~ /(roll|^Discount Rolls$)/i }.compact.sum
      self.raised_donut_count = line_items.collect{|line_item| line_item.quantity if line_item.item.name =~ /(raised|^Discount Donuts$)/i }.compact.sum
      self.cake_donut_count = line_items.collect{|line_item| line_item.quantity if line_item.item.name =~ /cake/i }.compact.sum
      self.price = self.delivery.total
    end
    self
  end
  
  def total
    (price.to_s.to_f + tax.to_s.to_f)
  end
  
  def customer
    delivery.customer
  end
  
  def self.period
    (Time.now.utc.day >= 15) ? { :start => (Time.now.utc.beginning_of_month+14.days), :end => Time.now.utc.end_of_month } : { :start => Time.now.utc.beginning_of_month, :end => (Time.now.utc.beginning_of_month+14.days) }
  end
  
  def self.metric_results
    paid.find(:all, :conditions => ["(created_at between ? and ?) and price > 50", period[:start], period[:end]])
  end
  
  def self.metric_chart
    months,counts = [],[]
    all.group_by{|bb| bb.created_at.to_date }.map{|month,bbs| 
    if d.first.created_at.to_date.year == Time.zone.now.year
        months << month.strftime("%h %Y").upcase
        counts << (bbs.map(&:total).sum/100).to_i
    end
  }
  "http://chart.apis.google.com/chart?chxt=Sales&cht=lc&chf=c,ls,0,CCCCCC,0.05,FFFFFF,0.05&chco=5D85BF&chd=t3:#{counts.join(',')}&chs=430x100&chl=#{months.uniq.join('|')}"
  end
  
  # def self.metric_chart
  #   chrt = GoogleChart.pie_3d_400x100(metrics)
  #   chrt.colors = CHART_COLORS[:pie]
  #   chrt
  # end
  
  def self.metrics
    m = {}
    metric_results.group_by{ |bb| bb.delivery.customer }.each{ |customer, buybacks| 
      m.merge!({customer.name => buybacks.map(&:price).sum})
    }
    m
  end
end
