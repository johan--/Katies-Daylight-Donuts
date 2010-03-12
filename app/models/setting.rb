class Setting < ActiveRecord::Base
  def self.for_application
    @setting ||= (first || create(:time_zone => APP_TIME_ZONE, :email => APP_EMAIL))
  end
  
  def self.email
    if first
      first.email
    else
      logger.warning " == You need to setup the default Setting record, sending mail to #{DEFAULT_EMAIL} for now."
      DEFAULT_EMAIL # failsafe
    end
  end
end
