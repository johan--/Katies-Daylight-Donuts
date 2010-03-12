class Position < ActiveRecord::Base  
  has_and_belongs_to_many :employees
  validates_uniqueness_of :name
  
  named_scope :driver, :conditions => {:name => "Driver"}
end
