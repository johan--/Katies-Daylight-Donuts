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
  
  context " when in order" do
    %w(Sun Mon Tue Wed Thu Fri Sat).each_with_index do |day, index|
      it "should have a position of #{index} when weekday is #{day}" do
        @delivery_preset.day_of_week = day
        @delivery_preset.position.should == index
      end
    end
  end
=begin
  context " when copied" do
    it "should not copy the day of week attribute" do
      copy_from = Factory(:delivery_preset, :day_of_week => "Sat")
      copy_to   = Factory(:delivery_preset, :day_of_week => "Tue")
      @delivery_preset.copy_attributes(copy_from,copy_to)
    end
    
    it "should copy the line items of the from model" do
      copy_from = Factory(:delivery_preset, :day_of_week => "Sat")
      copy_to   = Factory(:delivery_preset, :day_of_week => "Tue")
      DeliveryPreset.copy_attributes(copy_from,copy_to)
      copy_to.line_items.map(&:quantity).should == copy_from.line_items.map(&:quantity)
      copy_to.line_items.map(&:price).should == copy_from.line_items.map(&:price)
    end
    
    it "should raise an exception given a non delivery preset object" do
      lambda { @delivery_preset.copy_attributes("",nil) }.should raise_error(ArgumentError)
    end
  end
=end
end