class Customer < ActiveRecord::Base
  has_many :deliveries, :through => :locations
  has_many :locations, :as => :locatable, :dependent => :destroy
end
