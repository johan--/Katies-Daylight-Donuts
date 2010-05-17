require File.dirname(__FILE__) + '/../spec_helper'

describe Store do
  fixtures :stores, :cities
  
  context "class methods" do
    it "should create todays deliveries" do
      store = Factory(:store)
      Store.should_receive(:all_by_position).and_return([store])
      store.should_receive(:create_todays_delivery!)
      Store.create_todays_deliveries!
    end
  end
  
  context "instance methods" do
    it "should create todays deliveries" do
      Position.stubs(:driver).returns(Factory(:position))
      store = Factory(:store)
      store.deliveries.should_receive(:create).and_return(Factory(:delivery))
      store.create_todays_delivery!.should be_true
    end
  end
  
  context " on create" do
    it "should set the position" do
      store = Factory.create(:store)
      store.position.should_not be_blank
    end
    
    it "should not set the position given a position value" do
      store = Factory.create(:store, :position => 2)
      store.position.should == 2
    end
  end
  
  it "should order stores by position" do
    Store.all_by_position.should == [stores(:two),stores(:one)]
  end
  
  it "should return the next days preset" do
    Position.find_or_create_by_name(:name => "Driver")
    store = Factory(:store)
    Time.zone = "Central Time (US & Canada)"
    store.create_todays_delivery!
    store.todays_ticket.day_of_week.should == store.tomorrow
  end
  
  context "with an existing city" do
    it "should titleize the city_name" do
      store = Factory.create(:store)
      store.update_attribute(:city, Factory.create(:city, :name => "fooville") )
      store.city_name.should == "Fooville"
    end
    
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
