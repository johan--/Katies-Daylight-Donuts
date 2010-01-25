ActionController::Routing::Routes.draw do |map|
  map.resources :clockin_times

  map.resources :items, :collection => {
    :auto_complete_for_item_name => :get,
    :auto_complete_for_item_item_type => :get
  }

  map.resources :buy_backs

  map.resources :settings, :has_many => :locations

  map.resources :positions

  map.resources :locations, :has_many => [:deliveries, :customers, :settings], :collection => {
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
    :map => :get,
    :delivered => :get,
    :pending => :get
  }, :has_many => [:buy_backs, :items]

  map.resources :user_sessions
  map.resources :users
  
  map.forgot_password "forgot_password", :controller => "user_sessions", :action => "forgot_password"
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.screen_calculation "screen_calculation", :controller => "items", :action => "screen_calculation"
  
  map.root :locations
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
