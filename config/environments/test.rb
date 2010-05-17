# Gems
config.gem "rspec", :lib => false, :version => "= 1.3.0"
config.gem "rspec-rails", :lib => false , :version => "= 1.3.2"
config.gem "carlosbrando-remarkable", :lib => "remarkable", :source => "http://gems.github.com"
config.gem "factory_girl", :lib => "factory_girl", :version => "= 1.2.3"

config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = true

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test
config.action_mailer.perform_deliveries = true
config.time_zone = "Central Time (US & Canada)"

# Use SQL instead of Active Record's schema dumper when creating the test database.
# This is necessary if your schema can't be completely dumped by the schema dumper,
# like if you have constraints or database-specific column types
# config.active_record.schema_format = :sql
