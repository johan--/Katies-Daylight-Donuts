require 'spec_helper'

describe Admin::DashboardsController do
  setup :activate_authlogic
  
  before do
    @user = admin_user
    UserSession.create(@user.id)
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
