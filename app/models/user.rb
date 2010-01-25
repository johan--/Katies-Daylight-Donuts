class User < ActiveRecord::Base  
  require 'digest/md5' unless defined?(Digest::MD5)
  
  acts_as_authentic
  
  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :api_key, :if => Proc.new{ |u| u.api_enabled? } # generate an api key
  
  before_validation :generate_api_key

  def self.with_username_of_email(value)
    find(:first, :conditions => ["username = ? or email = ?", value, value])
  end
  
  def reset_password!
    new_password = digest(self.email + Time.now.to_s)
    self.password = self.password_confirmation = new_password
    UserNotifier.deliver_password(self,new_password)
    save
  end
  
  private
  
  def digest(value)
    Digest::MD5.hexdigest(value)
  end
    
  def generate_api_key
    return unless self.api_enabled?
    self.api_key = digest(Time.now.to_i.to_s + self.email + rand(999).to_s )
  end
end
