require 'spec_helper'

describe Dashboard do
  context "as a class" do
    it "should return item data" do
      Item.expects(:metrics)
      Dashboard.new.item_data
    end
    
    it "should reutn buyback data" do
      BuyBack.expects(:metrics)
      Dashboard.new.buyback_data
    end
  end
end