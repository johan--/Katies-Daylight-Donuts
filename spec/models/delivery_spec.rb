require File.dirname(__FILE__) + "/../spec_helper"


describe Delivery do
  it "should require an employee" do
    Delivery.create.errors.on(:employee).should == "Must be assigned to an employee."
  end
  
  it "should require a location" do
    Delivery.create.errors.on(:location).should == "Must be assigned a delivery location."
  end
end