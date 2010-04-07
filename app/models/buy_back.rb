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
  
  def total
    (price + tax)
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
    chrt = GoogleChart.pie_3d_400x100(metrics)
    chrt.colors = CHART_COLORS[:pie]
    chrt
  end
  
  def self.metrics
    m = {}
    metric_results.group_by{ |bb| bb.delivery.customer }.each{ |customer, buybacks| 
      m.merge!({customer.name => buybacks.map(&:price).sum})
    }
    m
  end
end
