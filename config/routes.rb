ActionController::Routing::Routes.draw do |map|
  map.resources :deliveries, :member => { 
      :deliver => :any,
      :undeliver => :any,
      :add_item => :any,
      :remove_item => :any
     }, :collection => {
    :search => :get,
    :canceled => :get,
    :printed => :get,
    :generate_todays => :any,
    :print_todays => :any,
    :map => :get,
    :delivered => :get,
    :pending => :get
  }, :has_many => [:buy_backs, :items, :comments]
  
  map.resources :faqs
  map.resources :schedules

  map.resources :delivery_presets, :member => {
    :remove_item => :any,
    :add_item => :any
  }

  map.resources :stores, :collection => { :sort => :post, :search => :post } do |store| 
    store.resources :delivery_presets, :collection => {
      :copy => :any
    }
    store.resources :deliveries, :member => { 
        :deliver => :any,
        :undeliver => :any,
        :add_item => :any,
        :remove_item => :any
       }, :collection => {
      :generate_todays => :any,
      :print_todays => :any,
      :map => :get,
      :delivered => :get,
      :pending => :get
    }, :has_many => [:buy_backs, :items, :comments]
  end
  

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

  map.resources :settings

  map.resources :positions

  map.resources :customers, :has_many => [:deliveries]

  map.resources :employees, 
    :member => {
      :timesheet => :get
    },
    :collection => {
      :validate_clockin_id_available => :any
    }, :has_many => [:clockin_times, :schedules]

  map.resources :comments

  map.resources :user_sessions
  map.resources :users, :has_one => :store
  
  map.timeclock "/timeclock", :controller => "clockin_times", :action => "new"
  map.customer_signup "/customers/signup", :controller => "customers", :action => "new"
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.screen_calculation "screen_calculation", :controller => "items", :action => "screen_calculation"
  map.turn_off_hints "hints/disabled", :controller => "users", :action => "turn_off_hints"
  map.root :dashboards
  map.connect ':controller/page/:page'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
