require 'spec_helper'

describe Admin::SchedulesController do

  setup :activate_authlogic
  
  before do
    @user = admin_user
    UserSession.create(@user.id)
  end

  #Delete this example and add some real ones
  it "should use SchedulesController" do
    controller.should be_an_instance_of(Admin::SchedulesController)
  end

end
