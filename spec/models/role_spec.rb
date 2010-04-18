require File.dirname(__FILE__) + '/../spec_helper'

describe Role do
  it "should return the admin role" do
    Role.admin.should == Role.find(:first, :conditions => {:name => "admin"})
  end
  
  it "should return the employee role" do
    Role.employee.should == Role.find(:first, :conditions => {:name => "employee"})
  end
  
  it "should return the customer role" do
    Role.customer.should == Role.find(:first, :conditions => {:name => "customer"})
  end
  
  it "should belong to many users" do
    role,user = Factory.create(:role, :name => "gamers"), Factory.create(:user)
    role.users << user
    user.roles.include?(role).should == true
  end
end
