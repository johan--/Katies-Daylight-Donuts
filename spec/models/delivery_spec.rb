require File.dirname(__FILE__) + "/../spec_helper"


describe Delivery do
  before(:each) do
    @delivery = Factory.create(:delivery)
  end
  
  context " any instance" do
    it "should have a store_name virtual attribute" do
      @delivery.respond_to?(:store_name).should == true
    end
  end
  
  context " with comments" do
    it "should have 1 comment" do
      comment = @delivery.comments.create(:body => "This is a comment...")
      @delivery.comments.include?(comment).should == true
    end
  end
end