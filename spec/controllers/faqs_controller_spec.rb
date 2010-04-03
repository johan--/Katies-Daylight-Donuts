require File.dirname(__FILE__) + '/../spec_helper'
 
describe FaqsController do
  fixtures :all
  integrate_views

  before(:each) do
    login
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
end
