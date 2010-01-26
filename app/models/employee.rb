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
    
  validates_uniqueness_of :phone
  validates_presence_of :firstname, :lastname, :born_on, :phone
  validates_presence_of :positions, :if => Proc.new{ |employee| employee.positions.empty? }
  
  has_and_belongs_to_many :positions
  has_many :clockin_times
  
  def hours
    clockin_times
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
end
