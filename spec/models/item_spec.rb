require 'spec_helper'

describe Item do
  before(:each) do
    @item = Factory.create(:item)
  end

  context " when invalid" do
    it "should require a unique name" do
      item = Item.new(:name => @item.name)
      item.should have(1).error_on(:name)
    end
    
    it "should be invalid without a price" do
      item = Item.new(:price => nil)
      item.should have(1).error_on(:price)
    end
    
    it "should be invalid without an item_type" do
      item = Item.new(:item_type => nil)
      item.should have(1).error_on(:item_type)
    end
  end

  context " when available" do
    it "should be returned in the available named scope" do
      @item.update_attribute(:available, true)
      Item.available.include?(@item).should == true
    end
  end

  it "should have valid item types defined" do
    Item::TYPES.should == ["roll","raised","cake","donut_hole","Supplies"]
  end
end
