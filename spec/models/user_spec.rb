require File.dirname(__FILE__) + "/../spec_helper"

describe User do
  before(:each) do
    @attributes = { 
      :username => "tester",
      :email => "me@timmatheson.com",
      :password => "password",
      :password_confirmation => "password",
    }
  end
  
  it "should require api_key when api is enabled" do
    User.create(@attributes.merge({:api_enabled => true})).api_key.should_not be_nil
  end
  
  it "should reset password" do
    user = User.create(@attributes.merge({:api_enabled => false}))
    user.expects(:crypted_password=).once
    user.reset_password!
  end
  
  it "should require username" do
    user = User.create(@attributes.except(:username))
    user.errors.on(:username).should == ["is too short (minimum is 3 characters)", "should use only letters, numbers, spaces, and .-_@ please.", "can't be blank"]
  end
  
end