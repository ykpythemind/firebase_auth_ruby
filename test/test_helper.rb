$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "firebase_auth_ruby"

require "minitest/autorun"
require "openssl"
require "jwt"

module TestHelper
  MOCK_PRIVATE_KEY = OpenSSL::PKey::RSA.new(File.read(File.expand_path("./private.pem", __dir__)))
  MOCK_PRIVATE_KEY_ID = "aaaaaaaaaabbbbbbbbbbccccccccccdddddddddd"

  def self.generate_id_token(project_id, additional_payload = {})
    iss = "https://securetoken.google.com/#{project_id}"
    aud = project_id

    now = Time.now.to_i

    payload = additional_payload.merge({
      exp: now + 3600,
      iat: now,
      aud: aud,
      iss: iss,
      sub: 'test',
      auth_time: now
    })

    headers = {
      'alg' => 'RS256',
      'kid' => MOCK_PRIVATE_KEY_ID
    }
    JWT.encode payload, MOCK_PRIVATE_KEY, 'RS256', headers
  end

  def self.generate_cookie_session(project_id, additional_payload = {})
    iss = "https://session.firebase.google.com/#{project_id}"
    aud = project_id

    now = Time.now.to_i

    payload = additional_payload.merge({
      exp: now + 3600,
      iat: now,
      aud: aud,
      iss: iss,
      sub: 'test',
      auth_time: now
    })

    headers = {
      'alg' => 'RS256',
      'kid' => MOCK_PRIVATE_KEY_ID
    }
    JWT.encode payload, MOCK_PRIVATE_KEY, 'RS256', headers
  end

  class FakeFetcher
    def fetch(*)
      { MOCK_PRIVATE_KEY_ID => File.read(File.expand_path("./cert.pem", __dir__)) }
    end
  end
end
