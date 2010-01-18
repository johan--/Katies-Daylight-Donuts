require File.dirname(__FILE__) + '/../spec_helper'
 
describe BuyBacksController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => BuyBack.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    BuyBack.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    BuyBack.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(buy_back_url(assigns[:buy_back]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => BuyBack.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    BuyBack.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BuyBack.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    BuyBack.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BuyBack.first
    response.should redirect_to(buy_back_url(assigns[:buy_back]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    buy_back = BuyBack.first
    delete :destroy, :id => buy_back
    response.should redirect_to(buy_backs_url)
    BuyBack.exists?(buy_back.id).should be_false
  end
end
