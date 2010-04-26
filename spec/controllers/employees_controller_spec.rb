require 'spec_helper'

describe EmployeesController do
  integrate_views
  
  before(:each) do
    login
  end
  
  it "should render the index action" do
    get :index
    response.should render_template(:index)
  end
end