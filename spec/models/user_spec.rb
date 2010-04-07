require File.dirname(__FILE__) + "/../spec_helper"

describe User do
  before(:each) do
    @valid_attributes = { 
      :username => "tester",
      :email => "me@timmatheson#{rand(99)}.com",
      :password => "password",
      :password_confirmation => "password",
    }
  end
  
  context " when invalid" do
    it "should require username" do
      Factory.create(:user, :username => nil).errors.on(:username).should == ["is too short (minimum is 3 characters)", "should use only letters, numbers, spaces, and .-_@ please.", "can't be blank","Username can only be letters and/or numbers"]
    end

    it "should be invalid with an invalid username" do
      Factory.create(:user, :username => ".3321ukd").valid?.should == false
    end
  end
  
  context " when valid" do 
    it "should be valid with a valid username" do
      attributes = @valid_attributes.dup
      attributes[:username] = "abc12322"  
      User.new(attributes).valid?.should == true
    end
  
    it "should be admin with and admin role" do
      User.any_instance.stubs(:valid?).returns(true)
      user = User.create(@valid_attributes)
      user.roles <<  Role.find_or_create_by_name("admin")
      user.admin?.should == true
    end
  
    it "should reset password" do
      user = User.create(@valid_attributes.merge({:api_enabled => false}))
      user.expects(:crypted_password=).once
      user.reset_password!
    end
  
    it "should be valid with a valid username" do
      attributes = @valid_attributes.dup
      attributes[:username] = "userme420"  
      User.new(attributes).valid?.should == true
    end
  
    it "should find a user by email" do
      user = User.create(@valid_attributes)
      User.with_username_or_email(@valid_attributes[:email]).should == user
    end
  
    it "should find a user by username" do
      user = User.create(@valid_attributes)
      User.with_username_or_email(@valid_attributes[:username]).should == user
    end
  
    it "should return username for to_param" do
      User.new(:username => "foo").to_param.should == "foo"
    end
  end
end