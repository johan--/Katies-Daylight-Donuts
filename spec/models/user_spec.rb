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
  
  context " any instance" do
    it "should be a facebooker user given a facebook_uid valud" do
      user = User.new(:facebook_uid => 123)
      user.facebooker?.should == true
    end
    
    it "should be a system user when employee" do
      user = Factory.create(:user)
      user.roles << Role.employee
      user.system_user?.should == true
    end
    
    it "should be a system user when admin" do
      user = Factory.create(:user)
      user.roles << Role.admin
      user.system_user?.should == true
    end
    
    it "should be a system user when username is admin" do
      user = User.new(:username => "admin")
      user.system_user?.should == true
    end
  end
  
  context " when invalid" do
    it "should require username" do
      user = User.new(:username => nil)
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

  it "should be a super user with admin as a username" do
    (User.find_by_username("admin") || Factory.create(:user, :username => "admin")).admin?.should == true
  end
  
  it "should be an employee user with an employee role" do
    user = Factory.create(:user)
    user.roles << Role.employee
    user.employee?.should == true
  end
  
  it "should be a customer user with a customer role" do
    user = Factory.create(:user)
    user.roles << Role.customer
    user.customer?.should == true
  end
  
  it "should be a customer user with a store given a customer role and store" do
    user = Factory.create(:user)
    user.roles << Role.customer
    user.store = Factory.create(:store)
    user.customer_with_store?.should == true
  end
  
  
  context " when valid" do 
    it "should be valid with a valid username" do
      Factory.create(:user, :username => Factory.next(:username)).valid?.should == true
    end
  
    it "should be admin with and admin role" do
      user = Factory.create(:user)
      user.roles << Role.admin
      user.admin?.should == true
    end
  
    it "should reset password" do
      user = Factory.create(:user, :api_enabled => false)
      user.expects(:crypted_password=).once
      user.reset_password!
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