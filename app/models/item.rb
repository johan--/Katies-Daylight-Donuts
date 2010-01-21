class Item < ActiveRecord::Base
  belongs_to :delivery
  
  validates_presence_of :name, :item_type, :price
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :deliveries
  
  named_scope :available, :conditions => {:available => true}
  
  TYPES = ["roll","raised","cake","donut_hole"]
  
  def self.types
    @types ||= TYPES.collect{ |t| t.titleize }
  end
end
