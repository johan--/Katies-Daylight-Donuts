class DashboardsController < ApplicationController
  before_filter :login_required
  before_filter :admin_role_required
  before_filter :get_current_weather
  
  def index
    @dashboard = Dashboard.new
  end
  
  protected
  
  def get_current_weather
    @client = YahooWeather::Client.new
    @weather = @client.lookup_by_woeid(12787871) # central city
  end
end
