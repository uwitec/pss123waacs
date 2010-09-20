# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_wcamp_session',
  :secret      => 'df58b2bc750d070278192746897f3ce662e9eacf611dc2ceb6a700c0731ce554f973c67462c3ddb749235b4583a84128f9a3b0fce6885171753b0a98a37e8a0c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
