module Admin::SchedulesHelper
  def current_schedule(time = nil)
    time_scope = time.nil? ? Time.zone.now : time
    format = "%m/%d/%Y"
    [time_scope.at_beginning_of_week.strftime(format), "-", time_scope.at_end_of_week.strftime(format)]
  end
  
  def current_weekday(str)    
    wkday = Time.zone.now.strftime("%a").downcase
    content_tag(:span, :class => wkday == str ? "current_weekday" : "") do
      if str == wkday
        str.titleize + "(Today)"
      else  
        str.titleize
      end
    end
  end
  
end
