class Customer < ActiveRecord::Base
  has_many :deliveries, :through => :locations
  has_many :locations, :dependent => :destroy
  
  def self.with_delivered_deliveries
    all.collect{ |c| c if c.deliveries.delivered.count > 0 }.compact
  end
  
  def self.delivered_deliveries
    deliveries.delivered
  end
end
