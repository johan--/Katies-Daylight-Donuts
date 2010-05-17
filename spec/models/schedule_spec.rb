require 'spec_helper'

describe Schedule do
  before(:each) do
    @employee = Factory.create(:employee)
  end
  
  context " when valid" do
    it "should be valid with a valid time range" do
      Schedule.new(:starts_at => Time.zone.now, 
                    :ends_at => (Time.zone.now+1.second),
                    :employee => @employee).should be_valid
    end
  end
  
  context " when invalid" do
    it "should be invalid with an invalid time range" do
      Schedule.new(:starts_at => Time.zone.now, :ends_at => (Time.zone.now-3.seconds)).should_not be_valid
    end
  end
  
  context " any instance" do
    it "should return the display date in the correct format" do
      schedule = Factory.create(:schedule)
      schedule.display_date.should == schedule.work_date.strftime("%m/%d/%Y")
    end
    
    it "shoould return the total hours from start to end" do
      Schedule.new(:starts_at => Time.zone.now, :ends_at => (Time.zone.now+1.hour)+30.minutes).total_hours.should == 1.5
    end

    it "should calculate and set the work_date" do
      time = Time.zone.now
      Schedule.create(:employee => @employee, 
        :starts_at => time, :ends_at => (time+2.hours)).work_date.should be_close(time, 1.day)
    end
  end
  
  context " any class object" do
    it "should find schedules for today through named_scope for_today" do
      schedule = Factory.create(:schedule)
      Schedule.for_today.include?(schedule).should == true
    end
    
    it "should find a schedule this week through named_scope for_this_week" do
      schedule = Factory.create(:schedule, :starts_at => (Time.zone.now+1.day), :ends_at => ((Time.zone.now+1.day)+1.hour))
      Schedule.for_this_week.include?(schedule).should == true
    end
  end
end
