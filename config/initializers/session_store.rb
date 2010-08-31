# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shp_session',
  :secret      => '0cda018f4d4d80fc1d7617ea5d4f063dad28c161e247f9211b57f12a08d67468ee03bc2761f7a285bec9585f8e515b85c6574539c91f7700395a31f47251d759'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
