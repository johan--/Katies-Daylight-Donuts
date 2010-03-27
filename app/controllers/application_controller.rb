# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_timezone
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected
  
  # Custom Error Pages
  def render_optional_error_file(status_code)
    known_codes = ["404", "422", "500", :not_found]
    status = interpret_status(status_code)

    if known_codes.include?(status_code)
      render :template => "/errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
    else
      render :template => "/errors/unknown.html.erb", :status => status, :layout => 'application.html.erb'
    end
  end
  
  def get_current_weather
    @client = YahooWeather::Client.new
    @weather = @client.lookup_by_woeid(12787871) # central city
  end

  def employee_role_required
    unless @current_user.admin? || @current_user.employee?
      flash[:error] = "Employee role required." 
      redirect_to user_url(@current_user) 
    end
  end

  def customer_role_required
    unless @current_user.admin? || @current_user.customer?
      flash[:error] = "Customer role required." 
      redirect_to user_url(@current_user)
    end
  end

  def admin_role_required
    unless @current_user.admin?
      flash[:error] = "Admin role required." 
      redirect_to user_url(@current_user)
    end
  end
  
  def set_timezone
    Time.zone = current_user.time_zone if current_user_session
  end
  
  def current_user_session
    return @current_user if defined?(@current_user_sessiom)
    @current_user_session ||= UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def login_required
    unless current_user_session
      flash[:error] = "Please login"
      redirect_to login_url 
    end
  end
end
