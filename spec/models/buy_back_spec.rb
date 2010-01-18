require File.dirname(__FILE__) + '/../spec_helper'

describe BuyBack do
  it "should be valid" do
    BuyBack.new.should be_valid
  end
end
