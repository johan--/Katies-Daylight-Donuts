require File.dirname(__FILE__) + '/../spec_helper'

describe ClockinTime do
  it "should be valid" do
    ClockinTime.new.should be_valid
  end
end
