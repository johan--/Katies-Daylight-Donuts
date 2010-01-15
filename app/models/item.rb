class Item < ActiveRecord::Base
  has_and_belongs_to_many :deliveries
  
  named_scope :available, :conditions => {:available => true}, :include => :deliveries
end
