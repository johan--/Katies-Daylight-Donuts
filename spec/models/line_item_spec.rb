require 'spec_helper'

describe LineItem do
  before(:each) do
    @delivery = Factory.create(:delivery)
    @line_item = Factory.create(:line_item, :delivery => @delivery)
  end
  
  it "should be a roll with an item_type of roll" do
    @line_item.item.item_type = "roll"
    @line_item.roll?.should == true
  end
  
  it "should be a donut with an item_type of donut" do
    @line_item.item.item_type = "raised"
    @line_item.donut?.should == true
  end
  
  it "should be a donut hole with an item_type of donut hole" do
    @line_item.item.item_type = "donut hole"
    @line_item.donut_hole?.should == true
  end
end