class Schedule < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
    
  belongs_to :employee
  
  validates_presence_of :employee, :starts_at, :ends_at
  
  before_save :validate_time
  before_save :set_work_date
  
  named_scope :for_this_week, :conditions => ["date(work_date) between ? and ?", Time.zone.now.at_beginning_of_week, Time.zone.now.at_end_of_week], :order => "work_date DESC"
  named_scope :for_today, :conditions => ["date(work_date) = ?", Time.zone.now.to_date]
  # named_scope, by_date
  # usage: 
  #  Schedule.by_date returns all for today
  #  Schedule.by_date(Time.zone.now+1.week) returns all for next week
  #  Schedule.by_date(Time.zone.now,(Time.zone.now+1.month)) returns all for the next month
  named_scope :by_date, lambda { |*args|
    args[0] ||= Time.zone.now.to_date
    {
      :order => "employee_id DESC",
      :conditions => ["work_date BETWEEN ? AND ?", args[0].beginning_of_day.to_s(:db), (args[1]||args[0]).end_of_day.to_s(:db)]
    }
  }
  
  def display_date
    self.work_date.strftime("%m/%d/%Y")
  end
  
  def starts
    self.starts_at.strftime("%I:%M %p")
  end
  
  def ends
    self.ends_at.strftime("%I:%M %p")
  end
  
  # Returns the total hours from start to end
  def total_hours
    ('%.02f' % ((ends_at - starts_at) / 1.hour)).to_f
  end
  
  private

  def set_work_date
    self.work_date = starts_at.to_date if self.work_date.blank?
  end
  
  def validate_time
    unless (self.starts_at < self.ends_at)
      errors.add("Start / End time must be atleast one second or more.","invalid")
    end
  end
end
