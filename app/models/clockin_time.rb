class ClockinTime < ActiveRecord::Base
  belongs_to :employee
  
  named_scope :clocked_in, :conditions => {:ends_at => nil}, :limit => 1
  named_scope :clocked_out, :conditions => "starts_at is not NULL and ends_at is not NULL"
  
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
    months,counts = [],[]
    all.group_by{|ct| ct.created_at.to_date }.map{|month,cts| 
    if cts.first.created_at.to_date.year == Time.zone.now.year
        months << month.strftime("%h %Y").upcase
        counts << cts.map(&:total_hours_integer).sum.to_i
    end
  }
  "http://chart.apis.google.com/chart?chxt=Sales&cht=lc&chf=c,ls,0,CCCCCC,0.05,FFFFFF,0.05&chco=5D85BF&chd=t3:#{counts.join(',')}&chs=430x100&chl=#{months.uniq.join('|')}"
  end
  
end
