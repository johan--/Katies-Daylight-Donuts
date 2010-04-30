require 'spec_helper'

describe RoutesController do
  before(:each) do
    @route = Factory.create(:route)
    login_with_admin
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
      response.should redirect_to(stores_path)
      Route.all.include?(@route).should == false
    end
  end

  describe "PUT 'update'" do
    it "should be successful" do
      put 'update', :id => @route.id, :route => { :name => "My Other Route" }
      response.should redirect_to(stores_path)
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post :create, :route => { :name => "Some Route" }
      response.should redirect_to(stores_path)
    end
  end
end
