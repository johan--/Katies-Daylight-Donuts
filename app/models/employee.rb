class Employee < ActiveRecord::Base
  include AASM
  
  aasm_column :state

  aasm_initial_state :clocked_out
  aasm_state :clocked_in
  aasm_state :clocked_out
  
  aasm_event :clockin do
    transitions :from => :clocked_out, :to => :clocked_in, :on_transition => :record_clockin!
  end
  
  aasm_event :clockout do
    transitions :from => :clocked_in, :to => :clocked_out, :on_transition => :record_clockout!
  end
    
  # validates_uniqueness_of :phone # I don't like this
  validates_presence_of :firstname, :lastname, :born_on, :phone
  validates_presence_of :positions, :if => Proc.new{ |employee| employee.positions.empty? }
  validates_length_of :phone, :is => 10
  
  has_and_belongs_to_many :positions
  has_many :clockin_times
  has_many :schedules
  
  named_scope :drivers, :conditions => {:positions => "in (#{Position.driver.id})"}
  
  # Finds or Creates a new employee with a driving position
  def self.default
    return drivers.first unless drivers.empty?
    employee = create(:firstname => "Joe", :lastname => "Default", :phone => "9492945624", :born_on => 20.years.ago)
    employee.make_driver
    employee.save!
    employee
  end
  
  def make_driver
    self.positions << Position.driver
  end
  
  def hours
    clockin_times
  end
  
  def lifetime_hours
    hours.clocked_out.inject([]) do |collection, record|
      collection << calculate_hours(record.starts_at,record.ends_at)
    end.sum
  end
  
  def average_hours
    return 0 if lifetime_hours == 0
    (lifetime_hours / hours.clocked_out.size)
  end
  
  def self.paginate_by_creation(params = {})
    paginate :all,
      :sort_key => params[:sort_key] || 'created_at',
      :sort_value => params[:sort_value],
      :sort_id => params[:sort_id],
      :sort_order => 'desc',
      :include => :positions,
      :limit => 2
  end
  
  def self.clockin_id_available?(id)
    find_by_clockin_id(id).nil?
  end
  
  def self.drivers
    all.collect{ |e| e if e.driver? }.compact
  end
  
  def fullname
    "#{firstname} #{lastname}"
  end
  
  def has_position?(position)
    positions.include?(position)
  end
  
  def driver?
    has_position?(Position.find_by_name("Driver"))
  end
  
  def dob
    born_on.strftime("%m/%d/%Y") unless born_on.nil?
  end
  
  private
  
  def record_clockin!
    if clocked_in?
      return false
    else
      return clockin_times.create(:starts_at => Time.zone.now)
    end
  end
  
  def record_clockout!
    if clocked_out?
      return false
    else
      return clockin_times.clocked_in[0].update_attribute(:ends_at,Time.zone.now)
    end
  end
  
  def calculate_hours(start, ends)
    ( (ends - start) / 3600 ).round(1)
  end
end
