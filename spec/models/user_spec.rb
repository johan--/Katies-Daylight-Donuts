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

  it "should be admin with and admin role" do
    User.any_instance.stubs(:valid?).returns(true)
    user = User.create(@attributes)
    user.roles <<  Role.find_or_create_by_name("admin")
    user.admin?.should == true
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
    user.errors.on(:username).should == ["is too short (minimum is 3 characters)", "should use only letters, numbers, spaces, and .-_@ please.", "can't be blank","Username can only be letters and/or numbers"]
  end
  
  it "should be invalid with an invalid username" do
    attributes = @attributes.dup
    attributes[:username] = "-4Abcde4321"  
    User.new(attributes).valid?.should == false
  end
  
  it "should be valid with a valid username" do
    attributes = @attributes.dup
    attributes[:username] = "userme420"  
    User.new(attributes).valid?.should == true
  end
  
  it "should find a user by email" do
    user = User.create(@attributes)
    User.with_username_or_email(@attributes[:email]).should == user
  end
  
  it "should find a user by username" do
    user = User.create(@attributes)
    User.with_username_or_email(@attributes[:username]).should == user
  end
  
  it "should return username for to_param" do
    User.new(:username => "foo").to_param.should == "foo"
  end
  
end