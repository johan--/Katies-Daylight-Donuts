# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_donutdepot_session',
  :secret      => '6f8bc435779316f88d9779172830254da61a75799e2a406b05d033dd899723a4166bb4b791eb5cbbe793318bebbf6c7bb4f9a1c898670cd3abe7aa4b5f90bf92'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
