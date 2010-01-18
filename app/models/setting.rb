class Setting < ActiveRecord::Base
  has_many :locations, :dependent => :destroy
  
  def self.for_application
    first
  end
  
  def self.email
    first.email
  end
end
