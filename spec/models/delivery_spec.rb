require File.dirname(__FILE__) + "/../spec_helper"


describe Delivery do
  should_have_many :comments, :as => :commentable
  should_have_many :line_items, :dependent => :destroy
  should_have_many :items, :through => :line_items
  should_have_many :buy_backs, :dependent => :destroy
  
  should_belong_to :employee
  should_belong_to :store
  should_belong_to :collection
  
  before do
    @delivery = Factory(:delivery)
  end
  
  context "future dated delivery" do
    it "should be returned in the pending by date named scope" do
      time = (Time.zone.now+1.month)
      @delivery.delivery_date = time
      @delivery.save
      Delivery.pending.by_date(time).include?(@delivery).should be_true
    end
  end
  
  context "next and previous records" do
    it "should return the next record" do
      delivery = Factory.create(:delivery)
      Delivery.should_receive(:next).with(@delivery).and_return([delivery])
      @delivery.next.should == delivery
    end
    
    it "should return the previous record" do
      delivery = Factory.create(:delivery)
      Delivery.should_receive(:previous).with(delivery).and_return([@delivery])
      delivery.previous.should == @delivery
    end
  end
  
  context "transitions" do
    it "should record the delivery time when entering delivered" do
      @delivery.update_attributes(:state => "pending")
      @delivery.should_receive(:record_delivery_time).and_return(true)
      @delivery.deliver!.should be_true
      @delivery.delivered?.should be_true
    end
  end
  
  context " any instance" do
    it "should have a store_name virtual attribute" do
      @delivery.respond_to?(:store_name).should == true
    end
    
    it "should calculate the total" do
      @delivery.line_items.create(:item => Factory(:item), :quantity => 1, :price => 1.50)
      @delivery.line_items.create(:item => Factory(:item), :quantity => 2, :price => 3.0)
      @delivery.total.should == 7.50
    end
    
    it "should return a phone number" do
      @delivery.store.tray_type = "Black"
      @delivery.store.phone = "9492945624"
      @delivery.phone.should == "(Black) - 9492945624"
    end
    
    it "should return the customer name" do
      @delivery.customer_name.should == @delivery.store.name
    end
    
    it "should format the delivery_time" do
      @delivery.delivery_time.should == @delivery.delivery_date.strftime("%m/%d/%Y %H:%M:%S %p")
    end
    
    it "should return the date" do
      @delivery.date.should == @delivery.delivery_date.strftime("%m/%d/%Y")
    end
    
    it "should return the address" do
      @delivery.address.should == "#{@delivery.store.display_name} - #{@delivery.store.to_google}"
    end
    
    it "should return the donut count" do
      @delivery.line_items.create(:item => Factory(:item, :item_type => "raised"), :quantity => 3, :price => 1)
      @delivery.donut_count.should == 3
    end
    
    it "should return the roll count" do
      @delivery.line_items.create(:item => Factory(:item, :item_type => "roll"), :quantity => 2, :price => 1)
      @delivery.roll_count.should == 2
    end
    
    it "should return the donut hole count" do
      @delivery.line_items.create(:item => Factory(:item, :item_type => "donut hole"), :quantity => 10, :price => 1)
      @delivery.donut_hole_count.should == 10
    end
  end
  
  context " with comments" do
    it "should have 1 comment" do
      comment = @delivery.comments.create(:body => "This is a comment...")
      @delivery.comments.include?(comment).should == true
    end
  end
end