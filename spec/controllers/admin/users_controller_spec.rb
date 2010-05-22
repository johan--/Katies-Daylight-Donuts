require 'spec_helper'

describe Admin::UsersController do
  fixtures :all
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
  
  it "should render the new action" do
    get :new
    response.should render_template(:new)
  end
  
  it "should render the edit action" do
    get :edit, :id => @user.id
    response.should render_template(:edit)
  end
  
  it "should render the show action" do
    get :show, :id => @user.id
    response.should render_template(:edit)
  end
  
  it "should redirect on create" do
    User.stubs(:save).returns(true)
    post :create
    response.should be_redirect
  end
end
