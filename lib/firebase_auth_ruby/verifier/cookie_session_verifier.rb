module FirebaseAuthRuby::Verifier
  class CookieSessionVerifier < Base
    # https://firebase.google.com/docs/auth/admin/manage-cookies#verify_session_cookie_and_check_permissions

    private

    def iss
      "https://session.firebase.google.com/#{project_id}"
    end

    def public_key_url
      "https://www.googleapis.com/identitytoolkit/v3/relyingparty/publicKeys"
    end
  end
end
