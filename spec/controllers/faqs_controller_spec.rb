require 'spec_helper'
 
describe FaqsController do
  fixtures :all
  integrate_views

  setup :activate_authlogic
  
  before do
    @user = Factory(:user, :store => Factory(:store))
    UserSession.create(@user.id)
  end  
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
end
