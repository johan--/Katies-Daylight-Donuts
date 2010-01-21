class Location < ActiveRecord::Base
  belongs_to :customer
  has_many :deliveries, :dependent => :destroy
    
  # Geocode the locations for mapping
  after_update  :get_geocode
  before_create :get_geocode
    
  validates_presence_of :address, :city, :state, :country, :zipcode
  validates_numericality_of :zipcode
  validates_length_of :state, :is => 2
  validates_uniqueness_of :lng, :lat
  
  acts_as_mappable
  
  def full_address
    <<-EOF
    #{address}<br />
    #{city}, #{state}<br />
    #{country} #{zipcode}
    EOF
  end
  
  def address_option
    return to_google unless self.customer
    "#{self.customer.name} - " + to_google
  end
  
  def to_google
    "#{address} #{city}, #{state}, #{country} #{zipcode}"
  end
  
  def geocode
    geocode_array.join(",")
  end

  def geocode_array
    [lat,lng]
  end

  private
  
  def get_geocode
    gc = Geokit::Geocoders::YahooGeocoder.geocode "#{address}, #{city}, #{state}"
    self.lat = gc.lat
    self.lng = gc.lng
  end
end
