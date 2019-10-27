require 'active_support/core_ext/module/attribute_accessors'
require "jwt"

module FirebaseAuthRuby
  class Error < StandardError; end

  mattr_accessor :cache_store
end

require "firebase_auth_ruby/version"

require "firebase_auth_ruby/util"
require "firebase_auth_ruby/public_key_fetcher"

require "firebase_auth_ruby/verifier/base"
require "firebase_auth_ruby/verifier/id_token_verifier"
require "firebase_auth_ruby/verifier/cookie_session_verifier"
