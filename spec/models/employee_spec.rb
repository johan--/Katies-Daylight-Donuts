require File.dirname(__FILE__) + "/../spec_helper"

describe Employee do
  
  context " a driver" do
    before :each do 
      @employee = Employee.create(:firstname => "Tim", :lastname => "Matheson", :born_on => Time.now, :phone => "9492945624")
      Position.find_or_create_by_name("Driver")
    end
    
    it "should require a phone number" do
      @employee.phone = nil
      @employee.save
      @employee.errors.on(:phone).include?("can't be blank").should == true
    end
    
    it "should require a 10 digit number given a phone number" do
      @employee.phone = "2945624"
      @employee.save
      @employee.errors.on(:phone).should == "is the wrong length (should be 10 characters)"
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