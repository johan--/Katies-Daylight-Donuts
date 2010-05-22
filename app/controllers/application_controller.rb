# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  #before_filter :set_facebook_session
  before_filter :load_settings
  #helper_method :facebook_session
  
  before_filter :set_timezone
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  if Rails.env == "production"
    # Declare exception to handler methods
    #rescue_from ActionController::UnknownAction, :with => :bad_record
    rescue_from Exception, :with => :show_error
    rescue_from ActiveRecord::RecordNotFound, :with => :bad_record
    rescue_from NoMethodError, :with => :show_error
  

  
    def bad_request; render :template => "/errors/500.html", :layout => "application", :status => 500; end
    def bad_record; render "/errors/404.html", :status => 404; end
    def show_error; render :template => "/errors/500.html", :layout => "application", :status => 500; end
  end
  
  def view_all?
    params[:view] == "all"
  end
  
  def success(message)
    flash[:notice] = message
  end
  
  def fail(message)
    flash[:warning] = message
  end
  
  helper_method :success
  helper_method :fail

  protected
  
  if Rails.env == "production"
    # Custom Error Pages
    def render_optional_error_file(status_code)
      known_codes = ["404", "422", "500", :not_found]
      status = interpret_status(status_code)
      raise Exception, status
      if known_codes.include?(status_code)
        render :template => "/errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
      else
        render :template => "/errors/unknown.html.erb", :status => status, :layout => 'application.html.erb'
      end
    end
  end
  
  def get_current_weather
    return if Rails.env == "test"
    begin
      @client = YahooWeather::Client.new
      @weather = @client.lookup_by_woeid(12787871) # central city
    rescue => e
      logger.error e.message
    end
  end

  def employee_role_required
    unless current_user.admin? || @current_user.employee?
      flash[:error] = "Employee role required." 
      redirect_to user_url(@current_user) 
    end
  end

  def customer_role_required
    unless current_user.admin? || @current_user.customer?
      flash[:error] = "Customer role required." 
      redirect_to user_url(@current_user)
    end
  end

  def admin_role_required
    unless current_user.admin?
      flash[:error] = "Admin role required." 
      redirect_to user_url(@current_user)
    end
  end
  
  def set_timezone
    Time.zone = current_user.time_zone if current_user_session
  end
  
  def login_required
    unless current_user_session
      flash[:error] = "Please login"
      redirect_to login_url 
    end
  end
  
  def find_store
    if params[:store_id]
      @store = Store.find(params[:store_id])
    elsif current_user.customer_with_store?
      @store = current_user.store
    end
  end
  
  def load_settings
    @setting ||= Setting.for_application
  end
  
  def load_deliveries
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.today
    @delivery_klass = (current_user.admin? || current_user.employee?) ? Delivery : current_user.store.deliveries.by_date(@date)
    
    # Order History
    if params[:store_id] && store = Store.find(params[:store_id])
      @deliveries = store.deliveries
    else    
      if params[:status] == "pending"
        @deliveries = @delivery_klass.pending.by_date(@date)
      elsif params[:status] == "delivered"
        @deliveries = @delivery_klass.delivered.by_date(@date)
      elsif params[:status] == "printed"
        @deliveries = @delivery_klass.printed.by_date(@date)
      elsif params[:status] == "canceled"
        @deliveries = @delivery_klass.canceled.by_date(@date)
      else
        @deliveries = @delivery_klass.by_date(@date)
      end
    end
  end
  
  def redirect_back_or_default(path)
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to path
  end
  
  def ensure_user_has_store
    return if current_user.system_user?
    unless !current_user.store.nil?
      flash[:notice] = "Let's setup your store."
      redirect_to new_store_path
      return
    end
  end
  

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

end
