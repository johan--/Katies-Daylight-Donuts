require File.dirname(__FILE__) + "/../spec_helper"

describe User do
  before(:each) do
    @attributes = { 
      :email => "me@timmatheson.com",
      :password => "password",
      :password_confirmation => "password",
    }
  end
  
  it "should require api_key when api is enabled" do
    User.create(@attributes.merge({:api_enabled => true})).api_key.should_not be_nil
  end
  
end