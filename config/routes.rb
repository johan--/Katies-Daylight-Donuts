ActionController::Routing::Routes.draw do |map|
  map.resources :stores

  map.resources :comments

  map.resources :dashboards

  map.resources :home
  map.resources :password_resets

  map.resources :clockin_times

  map.resources :items, :collection => {
    :auto_complete_for_item_name => :get,
    :auto_complete_for_item_item_type => :get
  }

  map.resources :buy_backs

  map.resources :settings, :has_many => :locations

  map.resources :positions

  map.resources :locations, :has_many => [:deliveries, :customers, :settings], :collection => {
    :presets => :post,
    :search => :get, 
    :auto_complete_for_location_address => :get, 
    :auto_complete_for_location_zipcode => :get, 
    :auto_complete_for_location_city => :get
  }

  map.resources :customers, :has_many => [:locations, :deliveries]

  map.resources :employees, 
    :member => {
      :timesheet => :get
    },
    :collection => {
      :validate_clockin_id_available => :any
    }, :has_many => :clockin_times

  map.resources :deliveries, :member => { 
      :deliver => :any,
      :undeliver => :any,
      :add_item => :any,
      :remove_item => :any
     }, :collection => {
    :generate_todays => :any,
    :map => :get,
    :delivered => :get,
    :pending => :get
  }, :has_many => [:buy_backs, :items, :comments]
  map.resources :comments

  map.resources :user_sessions
  map.resources :users
  
  map.customer_signup "/customers/signup", :controller => "customers", :action => "new"
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.screen_calculation "screen_calculation", :controller => "items", :action => "screen_calculation"
  
  map.root :dashboards
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
