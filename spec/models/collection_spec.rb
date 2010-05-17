require 'spec_helper'

describe Collection do
  before do
    @collection = Factory(:collection)
  end
  
  should_have_many :deliveries
  
  context "with deliveries" do
    it "should return the delivery ids" do
      delivery = Factory(:delivery)
      @collection.deliveries << delivery
      @collection.delivery_ids.should == [delivery.id]
    end
    
    it "should revert all deliveries to pending" do
      delivery = Factory(:delivery)
      @collection.deliveries.expects(:map).with(&:undeliver!)
      @collection.should_receive(:revert_delivery_states).and_return(true)
      delivery.deliver!
      @collection.deliveries << delivery
      @collection.destroy
    end
  end
end
