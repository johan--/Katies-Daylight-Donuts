require File.dirname(__FILE__) + '/../spec_helper'

describe Store do
  fixtures :stores
  
  
  context "without an email" do
    it "should be valid without an email" do
      store = stores(:one)
      store.email = nil
      store.should be_valid
    end
  
    it "should not create a user without an email" do
      store = stores(:one)
      store.email = nil
      store.save
      store.user.should == nil
    end
  end
  
  context "with an email" do
    it "should be valid with an email" do
      store = stores(:one)
      store.should be_valid
    end
  
    it "should not create a user without an email" do
      store = stores(:one)
      attributes = store.attributes.dup
      attributes[:name] = "My Hardware Store"
      store = Store.create(attributes)
      User.expects(:create_with_store).once.with(store)
      store.user.should_not be_nil
    end
  end
end
