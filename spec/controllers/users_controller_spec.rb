require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  fixtures :all
  integrate_views
  
  before(:each) do
    login
  end
  
  context " when admin" do
    before(:each) do
      login_with_admin
    end
    
    it "should render the index action" do
      get :index
      response.should render_template(:index)
    end
  end
  
  context " when a customer" do
    #pending "should show customer stuff"
  end
  
  context " when an employee" do
    #pending "should show employee stuff"
  end
end
