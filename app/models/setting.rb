class Setting < ActiveRecord::Base
  acts_as_mappable
  
  after_update  :get_geocode
  before_create :get_geocode
  before_validation :find_city
  
  def self.for_application
    @setting ||= (first || create(:time_zone => APP_TIME_ZONE, :email => APP_EMAIL))
  end
  
  def self.email
    if first
      first.email
    else
      logger.error " == You need to setup the default Setting record, sending mail to #{DEFAULT_EMAIL} for now."
      DEFAULT_EMAIL # failsafe
    end
  end
  
  
  private
  
  def find_city
    self.city = City.find_or_create_by_name(self.city).name
  end
  
  def get_geocode
    gc = Geokit::Geocoders::YahooGeocoder.geocode "#{address}, #{city}, #{state}"
    self.lat = gc.lat
    self.lng = gc.lng
  end
end
