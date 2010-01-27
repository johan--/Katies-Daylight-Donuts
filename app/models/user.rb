class User < ActiveRecord::Base  
  require 'digest/md5' unless defined?(Digest::MD5)
  
  acts_as_authentic
  
  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :api_key, :if => Proc.new{ |u| u.api_enabled? } # generate an api key
  validates_format_of   :username, :with => /[A-Za-z0-9]/, :message => "Username can only be letters and/or numbers"
  
  before_validation :generate_api_key

  def to_param
    username
  end

  def self.with_username_or_email(value)
    find(:first, :conditions => ["username = ? or email = ?", value, value])
  end
  
  def reset_password!
    new_password = digest(self.email + Time.now.to_s).slice(0,10)
    self.password = self.password_confirmation = new_password
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
