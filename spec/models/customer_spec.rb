require File.dirname(__FILE__) + '/../spec_helper'

describe Customer do
  fixtures :customers
  
  before :each do
    @customer = customers(:pump_and_pantry)
  end
  
end