require File.dirname(__FILE__) + "/../spec_helper"


describe Delivery do
  fixtures :employees
  
  it "should require an employee" do
    Delivery.create.errors.on(:employee).should == "Driver required."
  end
end