require File.dirname(__FILE__) + "/../spec_helper"

describe UserNotifier do
  before(:each) do
    @valid_attributes = { 
      :username => "tester",
      :email => "me@timmatheson.com",
      :password => "password",
      :password_confirmation => "password",
    }
  end
  
  context " when a user signs up" do
    it "should send the signup notification email" do
      User.any_instance.stubs(:valid?).returns(true)
      UserNotifier.expects(:deliver_signup_notification)
      User.create!( @valid_attributes )
    end
  end
end