module FirebaseAuthRuby::Verifier
  class IdTokenVerifier < Base
    # https://firebase.google.com/docs/auth/admin/verify-id-tokens

    private

    def iss
      "https://securetoken.google.com/#{project_id}"
    end

    def public_key_url
      "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"
    end
  end
end
