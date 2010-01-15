class Setting < ActiveRecord::Base
  has_many :locations, :as => :locatable, :dependent => :destroy
  
  def self.for_application
    first
  end
end
