require 'spec_helper'

describe Admin::DeliveriesController do
  fixtures :all
  integrate_views
  
  setup :activate_authlogic
  
  before do
    @user = admin_user
    @delivery = Factory(:delivery)
  end
  
  before :each do
    UserSession.create(@user.id)
  end
  
  it "should generate todays tickets" do
    Store.expects(:create_todays_deliveries!)
    get :generate_todays, :format => "js"
    response.should render_template(:generate_todays)
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
    get :edit, :id => @delivery.id
    response.should render_template(:edit)
  end
  
  it "should render the show action" do
    get :show, :id => @delivery.id
    response.should render_template(:show)
  end
  
  context " when valid" do
    it "should redirect on success after create" do
      post :create, :delivery => Factory.build(:delivery).attributes
      response.should redirect_to(admin_deliveries_path)
    end
    
    it "should redirect on success after update" do
      put :update, :id => @delivery.id, :delivery => {:delivery_date => (Time.now+2.days)}
      response.should redirect_to(admin_deliveries_path)
    end
  end
  
  context " when invalid" do
    it "should render the new action on failure after create" do
      post :create, :delivery => {:delivery_date => Time.now}
      response.should render_template(:new)
    end
    
    it "should render the edit action on failure after update" do
      put :update, :id => @delivery.id, :delivery => {:delivery_date => nil}
      response.should render_template(:edit)
    end
  end
end
