require File.dirname(__FILE__) + "/../spec_helper"

describe Employee do
  it "should have a driver" do
    e = Employee.create(:firstname => "Tim", :lastname => "Matheson", :born_on => Time.now, :phone => "9492945624")
    e.positions << Position.find_or_create_by_name("Driver")
    e.driver?.should == true
  end
end