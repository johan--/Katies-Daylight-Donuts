class DashboardsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  
  def index
    @dashboard = Dashboard.new
  end
end
