class Schedule < ActiveRecord::Base
  belongs_to :employee
  
  validates_presence_of :employee, :starts_at, :ends_at
  
  before_validation :validate_time, :message => "Start / End time must be atleast one second or more."
  
  named_scope :for_this_week, :conditions => ["date(work_date) between ? and ?", Time.zone.now.at_beginning_of_week, Time.zone.now.at_end_of_week], :order => "work_date DESC"
  
  def display_date
    self.work_date.strftime("%m/%d/%Y")
  end
  
  def starts
    self.starts_at.strftime("%I:%M %p")
  end
  
  def ends
    self.ends_at.strftime("%I:%M %p")
  end
  
  def total_hours
    ('%.02f' % ((ends_at - starts_at) / 1.hour)).to_f
  end
  
  private
  
  def validate_time
    (self.starts_at < self.ends_at)
  end
end
