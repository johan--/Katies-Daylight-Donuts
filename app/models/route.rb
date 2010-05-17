class Route < ActiveRecord::Base
  has_many :stores
  has_many :deliveries, :through => :stores
  has_many :buy_backs, :through => :stores
  
  validates_presence_of :name
  
  def self.with_deliveries
    find(:all, :include => [:deliveries, :stores]).map{|r| r unless r.deliveries.empty? }.compact
  end
  
  def option_name
    "------------ #{name} ----------------------"
  end
end
