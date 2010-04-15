class User < ActiveRecord::Base  
  require 'digest/md5' unless defined?(Digest::MD5)

  attr_accessor :roles_ids
  
  cattr_reader :per_page
  @@per_page = 20

  acts_as_authentic
    
  validate_email_field = false
  
  validates_presence_of   :api_key, :if => Proc.new{ |u| u.api_enabled? } # generate an api key
  validates_presence_of   :username
  validates_uniqueness_of :username
  validates_format_of     :username, :with => /^\w+$/i, :message => "Username can only be letters and/or numbers", :allow_blank => false, :allow_nil => false
  
  before_validation :generate_api_key
  
  has_and_belongs_to_many :roles
  
  has_one :store, :dependent => :destroy
  
  perishable_token_valid_for = 2.hours
  
  after_save :update_roles
  
    
  def self.create_with_store(store)
    user = create(
      :username => "#{store.safe_name}",
      :email => store.email,
      :password => "stunod",
      :password_confirmation => "stunod"
    )
    user
  end
  
  def has_role?(role)
    !self.roles.find_by_name(role.to_s).nil?
  end
  
  def has_roles?(*args)
    self.roles.collect{ |role| args.include?(role.name.to_sym) }.all?
  end
  
  def super?
    @is_super ||= (self.username == "admin" || self.admin?)
  end
  
  def admin?
    has_role?(:admin)
  end
  
  def employee?
    has_role?(:employee)
  end
  
  def customer?
    has_role?(:customer) || !store.nil?
  end

  def to_param
    username
  end

  def self.with_username_or_email(value)
    find(:first, :conditions => ["username = ? or email = ?", value, value])
  end
  
  def reset_password!
    return unless email
    new_password = digest(self.email + Time.now.to_s).slice(0,10)
    self.password = self.password_confirmation = new_password
    save
  end
  
  def store?
    user_type == "Store"
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
    self.api_key = digest(Time.zone.now.to_i.to_s + self.email + rand(999).to_s )
  end
end