class Customer < ActiveRecord::Base
  has_many :deliveries, :through => :locations
  has_many :locations, :dependent => :destroy
end
