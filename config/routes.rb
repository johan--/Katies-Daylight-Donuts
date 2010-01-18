ActionController::Routing::Routes.draw do |map|
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

  map.resources :employees

  map.resources :deliveries, :member => { 
      :deliver => :any,
      :undeliver => :any
     }, :collection => {
    :delivered => :get,
    :pending => :get
  }, :has_many => :buy_backs

  map.resources :user_sessions
  map.resources :users
    
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  
  map.root :locations
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
