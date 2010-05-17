require 'spec_helper'

describe Admin::EmployeesController do
  integrate_views
  
  setup :activate_authlogic
  
  before do
    @user = admin_user
    UserSession.create(@user.id)
  end
  
  it "should render the index action" do
    get :index
    response.should render_template(:index)
  end
end