require 'spec_helper'
 
describe Admin::StoresController do
  fixtures :all
  integrate_views
  
  setup :activate_authlogic
  
  before do
    @user = admin_user
    UserSession.create(@user.id)
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    store = Factory.create(:store)
    get :show, :id => store.id
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    post :create, :store => Factory.attributes(:store)
    response.should be_redirect
  end
  
  it "edit action should render edit template" do
    store = Factory.create(:store)
    store.should_receive(:valid?).and_return(true)
    get :edit, :id => store.id
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    store = Factory(:store)
    store.should_receive(:valid?).and_return(true)
    put :update, :id => store.id
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    store = Factory(:store)
    put :update, :id => store.id, :store => {:name => "woot"}
    response.should redirect_to( admin_store_url(store) )
    
  end
  
  it "destroy action should destroy model and redirect to index action" do
    mock_store = mock(Store)
    mock_store.expects(:destroy)
    Store.should_receive(:find).with("420").and_return(mock_store)
    delete :destroy, :id => "420"
    response.should redirect_to(admin_stores_url)
  end
end
