# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem "authlogic"
  config.gem "geokit"
  config.gem "aasm", :lib => false
  config.gem "calendar_date_select"
  config.gem "crack"
  config.gem "yahoo-weather"
  config.gem "prawn"
  config.gem "facebooker", :lib => false
  config.gem "twelve_hour_select"
  #config.gem 'mislav-will_paginate', 
  #    :lib => 'will_paginate', 
  #    :source => 'http://gems.github.com'

  # config.gem "twitter"

  config.active_record.observers = [:delivery_observer, :user_observer, :employee_observer,:store_observer]
  
  config.frameworks -= [:active_resource]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  config.time_zone = 'UTC'

  DEFAULT_EMAIL = "klynnknoll@hotmail.com"
  
  CHART_COLORS = {
    :pie => ["2663C4","E3DF1B"]
  }
end