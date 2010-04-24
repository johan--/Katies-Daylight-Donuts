class Item < ActiveRecord::Base
  TYPES = ["roll","raised","cake","donut_hole","Supplies"]
  belongs_to :delivery
  has_many :line_items, :dependent => :destroy
  
  validates_presence_of :name, :item_type, :price
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :deliveries
  
  named_scope :available, :conditions => {:available => true}
  named_scope :consumable, :conditions => ["item_type != ?",TYPES.last]

  def consumable?
    self.item_type != TYPES.last
  end
  
  def self.types
    @types ||= TYPES.collect{ |t| t.titleize }
  end
    
  def self.metric_chart(store = nil)
    chrt = GoogleChart.pie_3d_400x100(metrics(store).freeze)
    chrt.colors = CHART_COLORS[:pie] * (self.count / 2).round
    chrt
  end
  
  def self.metrics(store = nil)
    m = {}
    collection = store.nil? ? find(:all, :include => [:line_items], :conditions => ["item_type != ?",TYPES.last]) : store.line_items.map{|li| li.item unless li.item.item_type == TYPES.last}.flatten
    collection.each do |item|
      m["#{item.name}"] = item.line_items.map(&:quantity).to_s.sum
    end
    m
  end
end
