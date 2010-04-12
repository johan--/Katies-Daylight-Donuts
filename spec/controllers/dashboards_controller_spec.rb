require 'spec_helper'

describe DashboardsController do
  fixtures :all
  before(:each) do
    login
  end
   
  it "should render the dashboard view when admin" do
    User.any_instance.stubs(:admin?).returns(true)
    get :index
    response.should render_template(:index)
  end
  
  it "should not render the dashboard view when admin" do
    User.any_instance.stubs(:admin?).returns(false)
    get :index
    response.should be_redirect
  end
end
