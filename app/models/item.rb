class Item < ActiveRecord::Base
  belongs_to :delivery
  has_many :line_items
  
  validates_presence_of :name, :item_type, :price
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :deliveries
  
  named_scope :available, :conditions => {:available => true}
  
  TYPES = ["roll","raised","cake","donut_hole","Supplies"]
  
  def self.types
    @types ||= TYPES.collect{ |t| t.titleize }
  end
  
  def self.metric_chart
    chrt = GoogleChart.pie_3d_400x100(metrics.freeze)
    chrt.colors = CHART_COLORS[:pie] * (self.count / 2).round
    chrt
  end
  
  def self.metrics
    m = {}
    all.each do |item|
      m["#{item.name}"] = item.line_items.map(&:quantity).to_s.sum
    end
    m
  end
end
