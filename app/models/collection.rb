class Collection < ActiveRecord::Base
  has_many :deliveries, :dependent => :nullify
  
  before_destroy :revert_delivery_states
  
  def delivery_ids
    deliveries.map(&:id)
  end
  
  private
  
  def revert_delivery_states
    deliveries.map(&:undeliver!)
  end

end
