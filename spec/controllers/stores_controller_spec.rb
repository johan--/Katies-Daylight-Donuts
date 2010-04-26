require File.dirname(__FILE__) + '/../spec_helper'
 
describe StoresController do
  fixtures :all
  integrate_views
  
  before(:each) do
    login
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => stores(:one).id
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Store.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    Store.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(new_store_url)
  end
  
  it "edit action should render edit template" do
    get :edit, :id => stores(:one)
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Store.any_instance.stubs(:valid?).returns(false)
    put :update, :id => stores(:one)
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    Store.any_instance.stubs(:valid?).returns(true)
    put :update, :id => stores(:one)
    response.should redirect_to(store_url(assigns[:store]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    store = stores(:one)
    delete :destroy, :id => store
    response.should redirect_to(stores_url)
    Store.exists?(store.id).should be_false
  end
end
