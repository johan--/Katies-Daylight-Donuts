class Store < ActiveRecord::Base
  belongs_to :city
  belongs_to :user, :dependent => :destroy # customer
  has_many :deliveries, :dependent => :destroy
  has_many :line_items, :through => :deliveries
  has_many :delivery_presets, :dependent => :destroy
    
  # Geocode the locations for mapping
  after_update  :get_geocode
  before_create :get_geocode
  before_validation :find_or_create_city
  
  validates_uniqueness_of :name # important!
  
  validates_presence_of :name, :address, :city, :state, :country, :zipcode # important!
    
  validates_numericality_of :zipcode
  
  validates_length_of :state, :is => 2
  
  acts_as_mappable
  
  attr_accessor :manual_city
  
  named_scope :all_by_position, :order => "position asc"
  
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

  def find_or_create_city
    self.city = City.find_or_create_by_name(self.manual_city) unless self.manual_city.blank?
  end
  
  def get_geocode
    gc = Geokit::Geocoders::YahooGeocoder.geocode "#{address}, #{city}, #{state}"
    self.lat = gc.lat
    self.lng = gc.lng
  end
end
