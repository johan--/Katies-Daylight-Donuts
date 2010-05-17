require File.dirname(__FILE__) + '/../spec_helper'

describe BuyBack do
  before do
    @buy_back = Factory(:buy_back)
  end
  
  context "an instance" do
    it "should have an initial state of pending" do
      @buy_back.pending?.should be_true
    end
    
    it "should return the total" do
      @buy_back.price = 5.00
      @buy_back.tax = 1.23
      @buy_back.total.should == (5.00 + 1.23)
    end
  end
  
  context "when paid" do
    it "should transition from pending to paid" do
      @buy_back.expects(:state=).with("paid")
      @buy_back.pay!
      @buy_back.paid?.should be_true
    end
  end
  
  context "when voided" do
    it "should transition from paid to pending" do
      @buy_back.expects(:state=).with("paid")
      @buy_back.expects(:state=).with("pending")
      @buy_back.pay!
      @buy_back.void!
      @buy_back.voided?.should be_true
    end
  end
  
  context "on create" do
    it "should calculate the total" do
      buy_back = Factory.build(:buy_back)
      buy_back.expects(:calculate_total)
      buy_back.expects(:price=)
      buy_back.save.should be_true
    end
  end
  
  
end
