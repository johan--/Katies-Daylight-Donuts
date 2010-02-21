class Customer < ActiveRecord::Base
  has_many :deliveries, :through => :locations
  has_many :locations, :dependent => :destroy

  named_scope :with_locations, :include => :locations, :conditions => 'locations.id is not null'

  after_create :create_user_for_customer

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end
  
  def self.with_delivered_deliveries
    all.collect{ |c| c if c.deliveries.delivered.count > 0 }.compact
  end
  
  def self.delivered_deliveries
    deliveries.delivered
  end
  
  private
  
  def create_user_for_customer
    User.create_from_customer(self)
  end

end
