class User < ActiveRecord::Base  
  require 'digest/md5' unless defined?(Digest::MD5)
  
  acts_as_authentic
  
  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :api_key, :if => Proc.new{ |u| u.api_enabled? } # generate an api key
  
  before_validation :generate_api_key
  
  private
  
  def generate_api_key
    return unless self.api_enabled?
    self.api_key = Digest::MD5.hexdigest(Time.now.to_i.to_s + self.email + rand(999).to_s )
  end
end
