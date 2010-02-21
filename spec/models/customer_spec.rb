require File.dirname(__FILE__) + '/../spec_helper'

describe Customer do
  fixtures :customers
  
  before :each do
    @customer = customers(:pump_and_pantry)
  end
  
  it "should create a user record after create" do
    User.expects(:create).once
    customer = Customer.create(:name => "Foo Company")
  end
end