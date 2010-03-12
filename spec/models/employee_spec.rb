require File.dirname(__FILE__) + "/../spec_helper"

describe Employee do
  
  context " a driver" do
    before :each do 
      @employee = Employee.create(:firstname => "Tim", :lastname => "Matheson", :born_on => Time.now, :phone => "9492945624")
      Position.find_or_create_by_name("Driver")
    end
  
    it "should have a driver" do
      @employee.positions << Position.driver
      @employee.driver?.should == true
    end
  
    it "should make an employee a driver" do
      @employee.make_driver
      @employee.driver?.should == true
    end
    
    it "should create a default employee if no drivers exist" do
      employee = Employee.default
      Employee.drivers.include?(employee).should == true
    end
  end
  
end