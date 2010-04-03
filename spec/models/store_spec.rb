require File.dirname(__FILE__) + '/../spec_helper'

describe Store do
  fixtures :stores, :cities
  
  
  it "should order stores by position" do
    Store.all_by_position.should == [stores(:two),stores(:one)]
  end
  
  context "with a new city" do
    it "should create the store and the city" do
      attributes = stores(:one).attributes.dup
      store = Store.new(attributes)
      store.manual_city = "Timbucktu"
      store.save
      store.city.name.should == "Timbucktu"
    end
  end
  
  context "with an existing city" do
    it "should create the store with the city" do
      store = stores(:one)
      store.city = cities(:one)
      store.save
      store.city.name.should == "Grand Island"
    end
  end
  
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
  
    # it "should not create a user without an email" do
    #   store = stores(:one)
    #   attributes = store.attributes.dup
    #   attributes[:name] = "My Hardware Store"
    #   new_store = Store.create(attributes)
    #   User.expects(:create_with_store).once.with(new_store)
    #   new_store.user.should_not be_nil
    # end
  end
end
