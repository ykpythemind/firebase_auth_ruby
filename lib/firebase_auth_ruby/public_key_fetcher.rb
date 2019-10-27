require "forwardable"
require 'json'
require 'net/http'
require 'uri'

module FirebaseAuthRuby
  class PublicKeyFetcher
    extend Forwardable

    def_delegator ::FirebaseAuthRuby, :cache_store
    def_delegators :cache_store, :read, :write

    def initialize
      @cache_hit = false
    end

    def fetch(url)
      @cache_hit = false

      public_keys = read(public_keys_cache_key(url))
      public_keys_expire_at = read(expire_at_cache_key(url))

      public_keys_still_valid = public_keys && public_keys_expire_at && Time.now.to_i < public_keys_expire_at.to_i

      if public_keys_still_valid
        @cache_hit = true
        return public_keys
      end

      res = Util.get!(url)

      cache_control_header = res['cache-control']
      if cache_control_header
        parts = cache_control_header.split(',')
        parts.each { |part|
          subpart = part.strip.split('=')
          if subpart[0] == 'max-age'
            max_age = subpart[1].to_i
            write(expire_at_cache_key(url), Time.now.to_i + (max_age * 1000))
          end
        }
      end

      public_keys = JSON.parse(res.body)
      write(public_keys_cache_key(url), public_keys)

      public_keys
    end

    private

    def public_keys_cache_key(url)
      "firebase_auth_ruby/public_keys/#{url}"
    end

    def expire_at_cache_key(url)
      "firebase_auth_ruby/public_keys_expire_at/#{url}"
    end
  end
end
