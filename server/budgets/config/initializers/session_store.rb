# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_budget_session',
  :secret      => '6e80d25abfae04477625ae0a5d55310c1eabff4da2f1faa3fe725e07134ea7a75916f170757c3fb0abcc187285a054600b173b3358f48928b76e8dfe255bdf65'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
