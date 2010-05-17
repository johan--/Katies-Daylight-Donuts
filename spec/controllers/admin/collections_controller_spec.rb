require 'spec_helper'
 
describe Admin::CollectionsController do
  fixtures :all
  integrate_views
  
  setup :activate_authlogic
  
  before do
    @user = admin_user
    @collection = Factory.create(:collection)
  end
  
  before :each do
    UserSession.create(@user.id)
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
end
