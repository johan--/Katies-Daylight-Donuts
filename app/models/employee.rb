class Employee < ActiveRecord::Base
    
  validates_uniqueness_of :phone
  validates_presence_of :firstname, :lastname, :born_on, :phone
  validates_presence_of :positions, :if => Proc.new{ |employee| employee.positions.empty? }
  
  has_and_belongs_to_many :positions
  
  def self.paginate_by_creation(params = {})
    paginate :all,
      :sort_key => params[:sort_key] || 'created_at',
      :sort_value => params[:sort_value],
      :sort_id => params[:sort_id],
      :sort_order => 'desc',
      :include => :positions,
      :limit => 2
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
end
