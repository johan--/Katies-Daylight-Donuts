class Employee < ActiveRecord::Base
  has_and_belongs_to_many :positions
  
  def self.drivers
    all.collect{ |e| e if e.driver? }.compact
  end
  
  def fullname
    "#{firstname} #{lastname}"
  end
  
  def has_position?(position)
    positions.include?(position)
  end
  
  def driver?
    has_position?(Position.find_by_name("Driver"))
  end
  
  def dob
    born_on.strftime("%m/%d/%Y") unless born_on.nil?
  end
end
