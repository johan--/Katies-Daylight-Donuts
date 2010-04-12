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
      user = User.new(:username => "")
      user.should_not be_valid
      user.should have(4).error_on(:username)
      user.errors.on(:username).should == ["is too short (minimum is 3 characters)", "should use only letters, numbers, spaces, and .-_@ please.", "can't be blank", "Username can only be letters and/or numbers"]
    end

    it "should be invalid with an invalid username" do
      user = User.new(:username => "._3321ukd")
      user.should_not be_valid
      user.should have(2).error_on(:username)
      user.errors_on(:username).should == ["should use only letters, numbers, spaces, and .-_@ please.", "Username can only be letters and/or numbers"]
    end
  end
  
  context " when valid" do 
    it "should be valid with a valid username" do
      Factory.create(:user, :username => Factory.next(:username)).valid?.should == true
    end
  
    it "should be admin with and admin role" do
      pending "figure out wtf is wrong here"
      user = Factory.create(:user)
      user.roles << Role.find_or_create_by_name("admin")
      user.admin?.should == true
    end
  
    it "should reset password" do
      user = Factory.create(:user, :api_enabled => false)
      user.expects(:crypted_password=).once
      user.reset_password!
    end
  
    it "should be valid with a valid username" do
      Factory.create(:user, :username => Factory.next(:username)).valid?.should == true
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
      username = Factory.next(:username)
      User.new(:username => username).to_param.should == username
    end
  end
end