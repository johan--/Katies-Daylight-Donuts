class Setting < ActiveRecord::Base
  def self.for_application
    @setting ||= (first || create(:time_zone => APP_TIME_ZONE, :email => APP_EMAIL))
  end
  
  def self.email
    first.email
  end
end
