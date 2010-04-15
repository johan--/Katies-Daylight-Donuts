require 'spec_helper'

describe Schedule do
  it "should be valid with a valid time range" do
    Schedule.new(:starts_at => Time.now, :ends_at => (Time.now+1.second)).should be_valid
  end
  
  it "should be invalid with an invalid time range" do
    Schedule.new(:starts_at => Time.now, :ends_at => (Time.now-3.seconds)).should_not be_valid
  end
end
