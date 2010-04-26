class ClockinTime < ActiveRecord::Base
  belongs_to :employee
  
  named_scope :clocked_in, :conditions => {:ends_at => nil}, :limit => 1
  named_scope :clocked_out, :conditions => "starts_at is not NULL and ends_at is not NULL"
  named_scope :by_date, lambda { |*args|
    args[0] ||= Time.zone.now
    {
      :order => "starts_at asc",
      :conditions => ["starts_at BETWEEN ? AND ?", args[0].beginning_of_day.to_s(:db), (args[1]||args[0]).end_of_day.to_s(:db)],
      :include => [:employee]
    }
  }
  
  attr_accessor :clockin_id
  
  def total_hours
    ((active? ? Time.zone.now : ends_at) - starts_at) / 1.hour
  end
  
  def total_hours_integer
    total_hours.to_i
  end
  
  def active?
    ends_at.nil?
  end
  
  def self.metric_chart
    return @metric_payload if defined?(@metric_payload)
    @metric_payload = []
    by_date(Time.zone.now.at_beginning_of_year,Time.zone.now).group_by(&:employee).map{ |employee, cts|
      @metric_payload.push( [employee.fullname,cts.map(&:total_hours_integer).sum] )
    }
    @metric_payload
  end
  
end
