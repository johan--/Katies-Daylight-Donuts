class DashboardsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  before_filter :get_current_weather, :only => :index
  
  def index
    @dashboard = Dashboard.new
  end
end
