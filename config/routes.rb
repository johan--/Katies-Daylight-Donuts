ActionController::Routing::Routes.draw do |map|

  map.resources :settings, :has_many => :locations

  map.resources :positions

  map.resources :locations, :has_many => [:deliveries, :customers, :settings], :collection => {
    :search => :get
  }

  map.resources :customers, :has_many => [:locations, :deliveries]

  map.resources :employees

  map.resources :deliveries, :member => { 
      :deliver => :any,
      :undeliver => :any
     }, :collection => {
    :delivered => :get,
    :pending => :get
  }

  map.resources :user_sessions
  map.resources :users
    
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  
  map.root :locations
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
