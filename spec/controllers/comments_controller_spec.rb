require File.dirname(__FILE__) + '/../spec_helper'
 
describe CommentsController do
  fixtures :all
  integrate_views
  
  before(:each) do
    login
  end
  
  it "update action should render edit template when model is invalid" do
    Comment.any_instance.stubs(:valid?).returns(false)
    put :update, :id => comments(:one)
    response.body.should be_blank
  end
  
  it "update action should redirect when model is valid" do
    Comment.any_instance.stubs(:valid?).returns(true)
    put :update, :id => comments(:one)
    response.should redirect_to(deliveries_url)
  end
  
  it "create action should render new template when model is invalid" do
    Comment.any_instance.stubs(:valid?).returns(false)
    Delivery.any_instance.stubs(:find).returns(mock(:delivery))
    post :create
    response.body.should be_blank
  end
  
  it "create action should redirect when model is valid" do
    Comment.any_instance.stubs(:valid?).returns(true)
    Delivery.stubs(:find).returns(mock(:delivery))
    post :create, :commentable_id => nil
    response.should redirect_to(deliveries_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    delete :destroy, :id => comments(:one)
    response.should redirect_to(deliveries_url)
    
    Comment.exists?(comments(:one).id).should be_false
  end
end
