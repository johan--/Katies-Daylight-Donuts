require 'spec_helper'

describe ClockinTime do
  should_belong_to(:employee)
  
  before do
    @clockin_time = Factory(:clockin_time, :ends_at => nil)
  end
  
  context "any instance" do
    it "should have a clockin_id attr_accessor" do
      @clockin_time.respond_to?(:clockin_id).should be_true
    end
    
    it "should return the correct total hours" do
      @clockin_time.starts_at = Time.now
      @clockin_time.ends_at = ((Time.now+1.hour)+30.minutes)
      @clockin_time.total_hours.should be_close(1.5, 1)
    end
  end
  
  context "when clocked in" do
    it "should be active" do
      @clockin_time.active?.should be_true
    end
    
    it "should be returned in the current scope" do
      ClockinTime.current.include?(@clockin_time).should be_true
    end
    
    it "should be returned in the clocked_in scope" do
      ClockinTime.clocked_in.include?(@clockin_time).should be_true
    end
    
    it "should not be returned in the clocked_out scope" do
      ClockinTime.clocked_out.include?(@clockin_time).should be_false
    end
  end
end
