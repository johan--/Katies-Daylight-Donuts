require 'spec_helper'

describe FormBuilder do
  it "should render the time select fields" do
    select = ActionView::Helpers::FormBuilder.new.twelve_hour_select("schedule","starts_at")
    select.should == ""
  end
end