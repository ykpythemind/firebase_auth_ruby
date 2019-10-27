
module FirebaseAuthRuby::Verifier
  class Base
    def self.verify!(token:, project_id:, public_key_fetcher: PublicKeyFetcher.new)
      new(
        token: token,
        project_id: project_id,
        public_key_fetcher: public_key_fetcher
      ).verify!
    end

    def initialize(token:, project_id:, public_key_fetcher:)
      @token = token
      @project_id = project_id
      @public_key_fetcher = public_key_fetcher
    end

    def verify!
      public_key = fetch_and_check_public_key!

      decode_with_pubkey!(public_key)
    end

    private

    attr_reader :token, :project_id, :public_key_fetcher

    def fetch_and_check_public_key!
      public_keys = public_key_fetcher.fetch(public_key_url)

      decoded =
        JWT.decode token,
                    nil,
                    false,
                    verify_iat: true,
                    verify_aud: true, aud: project_id,
                    verify_iss: true, iss: iss

      headers = decoded[1]
      kid = headers['kid'] || raise(Error, %("kid" not found in JWT header))

      raise Error, %("kid" claim does not correspond to a known public key.) unless public_keys.key?(kid)

      public_keys[kid]
    end

    def decode_with_pubkey!(public_key)
      cert = OpenSSL::X509::Certificate.new(public_key)
      decoded =
        JWT.decode token,
                   cert.public_key,
                   true,
                   algorithm: 'RS256',
                   iss: iss, verify_iss: true,
                   aud: project_id, verify_aud: true,
                   verify_iat: true

      decoded[0]
    end

    def iss
      raise NotImplementedError
    end

    def public_key_url
      raise NotImplementedError
    end
  end
end
