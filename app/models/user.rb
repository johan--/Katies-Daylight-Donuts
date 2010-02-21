class User < ActiveRecord::Base  
  require 'digest/md5' unless defined?(Digest::MD5)

  attr_accessor :roles_ids
  
  acts_as_authentic
    
  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :api_key, :if => Proc.new{ |u| u.api_enabled? } # generate an api key
  validates_format_of   :username, :with => /[A-Za-z0-9]/, :message => "Username can only be letters and/or numbers"
  
  before_validation :generate_api_key
  
  has_and_belongs_to_many :roles
  
  perishable_token_valid_for = 2.hours
  
  after_save :update_roles
  
  def has_role?(role)
    roles.find_by_name(role.to_s)
  end
  
  def has_roles?(*args)
    self.roles.collect{ |role| args.include?(role.name.to_sym) }.all?
  end
  
  def super?
    self.username == "admin"
  end
  
  def admin?
    has_role?(:admin)
  end
  
  def employee?
    has_role?(:employee)
  end
  
  def customer?
    has_role?(:customer)
  end

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
  
  # Creates a user from a customer,
  # Called on the after_create callback of Customer
  def self.create_from_customer(customer)
    create(
      :username => "#{customer.to_param}",
      :password => "katies",
      :password_confirmation => "katies",
      :email => customer.email
    )
  end
  
  private

  def update_roles
    return if self.roles_ids.nil? || self.roles_ids.empty? 
    self.roles = Role.find(self.roles_ids)
  end
  
  def digest(value)
    Digest::MD5.hexdigest(value)
  end
    
  def generate_api_key
    return unless self.api_enabled?
    self.api_key = digest(Time.now.to_i.to_s + self.email + rand(999).to_s )
  end
end
