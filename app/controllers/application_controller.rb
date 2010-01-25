# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_timezone
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  private
  
  def set_timezone
    Time.zone = @current_user.time_zone if @current_user
  end
  
  def current_user_session
    return @current_user if defined?(@current_user_sessiom)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = @current_user_session && @current_user_session.record
  end
  
  def login_required
    unless current_user_session
      flash[:error] = "Please login"
      redirect_to login_url 
    end
  end
end
