# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oauthserver_session',
  :secret      => '3364d0a91a3d95bcda870caa9814941f78102c1758f3296c4c2c65040be78d125c60545f64b1dbc181a2b33520c0b27dbb43e0899760772bd5234ecde9e50dc6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
