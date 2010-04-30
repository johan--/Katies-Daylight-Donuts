require File.dirname(__FILE__) + '/../spec_helper'
 
describe DeliveryPresetsController do
  fixtures :all
  integrate_views
  
  before(:each) do
    UserSession.any_instance.stubs(:find).returns(Factory.create(:user))
    login
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    DeliveryPreset.any_instance.stubs(:find).returns(delivery_presets(:mon))
    get :show, :id => delivery_presets(:mon)
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    DeliveryPreset.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    DeliveryPreset.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(edit_delivery_preset_url(assigns[:delivery_preset]))
  end
  
  it "edit action should render edit template" do
    DeliveryPreset.stubs(:find_or_create_by_day_of_week).returns(mock(:delivery_preset, :day_of_week => "mon"))
    get :edit, :id => delivery_presets(:mon)
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    put :update, { :id => delivery_presets(:tue).id, :delivery_preset => { :day_of_week => nil } }
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    line_item = {:item_id => 1, :quantity => 12, :price => 0.5}
    next_delivery_preset = mock(:delivery_preset, {:day_of_week => 'tue'})
    DeliveryPreset.any_instance.stubs(:valid?).returns(true)
    DeliveryPreset.stubs(:find_by_day_of_week).with('tue').returns(next_delivery_preset)
    put :update, :id => delivery_presets(:mon), :delivery_preset => {:day_of_week => 'mon', :line_items => [line_item] }
    response.should redirect_to(edit_delivery_preset_path(next_delivery_preset))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    delivery_preset = delivery_presets(:mon)
    id = delivery_preset.id
    delete :destroy, :id => delivery_preset
    response.should redirect_to(delivery_presets_url)
    DeliveryPreset.exists?(id).should be_false
  end
end
