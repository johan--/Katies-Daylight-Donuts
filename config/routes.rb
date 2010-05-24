ActionController::Routing::Routes.draw do |map|
  map.resources :locations, :only => :index, :collection => {:search => :any}
  map.namespace :api do |api|
    api.resource :sms, :only => [:outgoing,:incoming, :index], :collection => {:outgoing => :any, :incoming => :post}
  end
  
  map.namespace :admin do |admin|
    admin.resource :sms, :only => [:index,:create, :new]
    admin.resources :sms, :only => [:show, :index]
    admin.resources :users, :collection => { :search => :any }, :has_one => :store
    admin.resources :collections, :member => {:rollback => :any}
    admin.resources :buy_backs
    admin.resources :clockin_times, :member => {:clockin => :any, :clockout => :any}
    admin.resources :comments
    admin.resources :positions
    admin.resources :routes
    admin.resources :schedules
    admin.resources :delivery_presets
    admin.resources :settings
    admin.resources :employees, 
      :member => {
        :timesheet => :get
      },
      :collection => {
        :validate_clockin_id_available => :any
      }, :has_many => [:clockin_times, :schedules]
      
    admin.resources :items, :collection => {
      :auto_complete_for_item_name => :get,
      :auto_complete_for_item_item_type => :get
    }
    admin.resources :dashboards, :collection => { :exports => :get, :export => :post }
    admin.resources :stores, :collection => { :sort => :post, :search => :post },
      :has_many => [:deliveries]
      
    admin.resources :deliveries, :member => { 
        :deliver => :any,
        :undeliver => :any,
        :add_item => :any,
        :remove_item => :any
       }, :collection => {
      :by_date => :get,
      :search => :get,
      :canceled => :get,
      :printed => :get,
      :generate_todays => :any,
      :print_todays => :any,
      :map => :get,
      :delivered => :get,
      :pending => :get
    }, :has_many => [:buy_backs, :items, :comments]
  end

  # Public Routes
  map.resources :store, :has_many => [:deliveries, :buy_backs]
  map.resources :deliveries, :member => { 
      :add_item => :any,
      :remove_item => :any
     }, :collection => {
    :by_date => :get,
    :search => :get,
    :canceled => :get,
    :printed => :get,
    :delivered => :get,
    :pending => :get
  }, :has_many => [:buy_backs, :items, :comments], :belongs_to => :store
  
  map.resources :faqs
  map.resources :delivery_presets, :member => {
    :remove_item => :any,
    :add_item => :any
  }

  map.resources :home
  map.resources :password_resets
  map.resources :user_sessions
  map.resources :users, :has_one => :store

  map.connect "/admin", :controller => "admin/deliveries", :action => "index"
  map.timeclock "/admin/timeclock", :controller => "admin/clockin_times", :action => "new"
  map.password_reset "/password/reset", :controller => "password_resets", :action => "index", :conditions => {:method => :get}
  map.connect "/password/reset", :controller => "password_resets", :action => "create", :conditions => {:method => :post}
  map.login "/login", :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.connect "/login", :controller => "user_sessions", :action => "create", :conditions => {:method => :post}
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.screen_calculation "screen_calculation", :controller => "admin/items", :action => "screen_calculation"
  map.turn_off_hints "hints/disabled", :controller => "users", :action => "turn_off_hints"
  map.root :deliveries
  map.connect ':controller/search/:q'
  map.connect ':controller/page/:page'
  map.connect ':controller/:year/:month/:day',
    :action => "index",
    :month => nil,
    :day => nil,
    :requirements => {  :year => /\d{4}/,
                        :day => /\d{1,2}/,
                        :month => /\d{1,2}/ }
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '/admin/timeclock/clockout/:id', :controller => "/admin/clockin_times", :action => "clockout"
  map.connect '/locations/city/:name', :controller => "locations", :action => "city"
end
