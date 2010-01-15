class Company < ActiveRecord::Base
  has_many :locations, :as => :locatable, :dependent => :destroy
end
