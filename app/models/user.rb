class User < ActiveRecord::Base  
  cattr_reader :per_page
  @@per_page = 10
  
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
  has_many :sms
  has_one :store, :dependent => :destroy
  
  perishable_token_valid_for = 2.hours
  
  after_save :update_roles
  
  
  # Facebook Connect Hook
  #def before_connect(facebook_session)
  #  self.email = facebook_session.user.email
  #  self.username = facebook_session.user.name.gsub(/[^A-Za-z0-9\_]/,'').downcase
  #  self.password = self.password_confirmation = "stunod"
  #  self.roles << Role.customer
  #end
  
  def self.nobody
    @nobody ||= find_or_create_by_username("nobody")
  end
  
  def self.paginate_search(options = {})
    query = "%"+options[:q]+"%"
    paginate :page => (options[:page] || 1), 
      :order => "created_at DESC", 
      :conditions => ["username like ? or email like ?", query, query]
  end
    
  def self.create_with_store(store)
    user = create(
      :username => "#{store.safe_name}",
      :email => store.email,
      :password => "stunod",
      :password_confirmation => "stunod"
    )
    user
  end
  
  def number_or_email
    mobile_number || email || "unknown"
  end
  
  def has_role?(role)
    !self.roles.find_by_name(role.to_s).nil?
  end
  
  def has_roles?(*args)
    self.roles.collect{ |role| args.include?(role.name.to_sym) }.all?
  end
  
  def system_user?
    @system_user ||= (admin? || super? || employee?)
  end
  
  def super?
    @is_super ||= (self.username == "admin" || self.admin?)
  end
  
  def admin?
    @admin ||= has_role?(:admin)
  end
  
  def employee?
    @employee ||= has_role?(:employee)
  end
  
  def customer?
    @customer ||= has_role?(:customer)
  end
  
  def customer_with_store?
    customer? && !store.nil?
  end
  
  def facebooker?
    !facebook_uid.blank?
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
  
  def store_name
    self.store.nil? ? "n/a" : store.name
  end

  def self.find_and_return_json(method, options = {})
    result = Hash.new
    result[:totalCount] = self.count
    result[:users] = []
    find(method.to_sym, options).map do |user|
      result[:users] << {
        :id => "<a href='/admin/users/#{user.to_param}'>#{user.id}</a>",
        :created_at => grid_date(user.created_at),
        :store_name => "<a href='/admin/stores/#{user.store.to_param}'>#{user.store_name}</a>",
        :username => "<a href='/admin/users/#{user.id}'>#{user.username}</a>",
        :email => "<a href='mailto:#{user.email}'>#{user.email}</a>",
        :tools => "Coming Soon"
      }
    end
    result.to_json
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