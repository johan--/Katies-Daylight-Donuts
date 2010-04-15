require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  fixtures :all
  integrate_views
  
  before(:each) do
    login
  end
  
  it "should render the index action" do
    get :index
    response.should render_template(:index)
  end
end
