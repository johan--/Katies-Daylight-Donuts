class Store < ActiveRecord::Base
  
  belongs_to :user # customer
  has_many :deliveries, :dependent => :destroy
    
  # Geocode the locations for mapping
  after_update  :get_geocode
  before_create :get_geocode
  
  validates_uniqueness_of :name # important!
  
  validates_presence_of :name, :email, :address, :city, :state, :country, :zipcode # important!
  
  validates_numericality_of :zipcode
  
  validates_length_of :state, :is => 2
  
  acts_as_mappable
  
  def display_name
    @display_name ||= [name, store_no].join(" - ")
  end
  
  def full_address
    <<-EOF
    #{address}<br />
    #{city}, #{state}<br />
    #{country} #{zipcode}
    EOF
  end
  
  def address_option
    to_google
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

  # Returns a safe name for creating a username
  def safe_name
    name.gsub(/[^A-Za-z0-9\.\_]/,'').downcase
  end

  private
  
  def get_geocode
    gc = Geokit::Geocoders::YahooGeocoder.geocode "#{address}, #{city}, #{state}"
    self.lat = gc.lat
    self.lng = gc.lng
  end
end
