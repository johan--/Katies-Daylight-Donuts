require File.dirname(__FILE__) + "/../spec_helper"

describe DeliveryPreset do
  before(:each) do
    @delivery_preset = Factory(:delivery_preset)
  end
  
  context " when valid" do
    it "should be valid" do
      @delivery_preset.valid?.should == true
    end
  end
  
  context " when invalid" do
    it "should be invalid without a day of week" do
      @delivery_preset.day_of_week = nil
      @delivery_preset.valid?.should == false
    end
  end
  
  context " when copied" do
    it "should not copy the day of week attribute" do
      copy_from = Factory(:delivery_preset)
      @delivery_preset.copy(copy_from)
      @delivery_preset.items.map(&:id).should == copy_from.items.map(&:id)
    end
  end
end