require 'spec_helper'

describe Admin::RoutesController do

  setup :activate_authlogic
  
  before do
    @user = admin_user
    UserSession.create(@user.id)
    @route = Factory.create(:route)
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should render_template(:new)
    end
  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => @route.id
      response.should render_template(:edit)
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      delete 'destroy', :id => @route.id
      response.should redirect_to(admin_stores_path)
      Route.all.include?(@route).should == false
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :id => @route.id, :route => { :name => "My Other Route" }
      response.should redirect_to(admin_stores_path)
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post :create, :route => { :name => "Some Route" }
      response.should redirect_to(admin_stores_path)
    end
  end
end
