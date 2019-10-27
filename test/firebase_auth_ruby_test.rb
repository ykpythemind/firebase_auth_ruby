require "test_helper"

class FirebaseAuthRubyTest < Minitest::Test
  def setup
    FirebaseAuthRuby.cache_store = ActiveSupport::Cache::NullStore.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::FirebaseAuthRuby::VERSION
  end

  def test_id_token_verifier
    project_id = 'test_project_id'
    id_token = TestHelper.generate_id_token(project_id, {piyo: 'fuga'})

    decoded = FirebaseAuthRuby::Verifier::IdTokenVerifier.verify!(token: id_token, project_id: project_id, public_key_fetcher: TestHelper::FakeFetcher.new)

    assert decoded['exp']
    assert decoded['iat']
    assert_equal project_id, decoded['aud']
    assert_equal "https://securetoken.google.com/#{project_id}", decoded["iss"]
    assert_equal "test", decoded['sub']
    assert_equal 'fuga', decoded['piyo']
  end

  def test_cookie_session_verifier
    project_id = 'test_project_id'
    id_token = TestHelper.generate_cookie_session(project_id, {piyo: 'fuga'})

    decoded = FirebaseAuthRuby::Verifier::CookieSessionVerifier.verify!(token: id_token, project_id: project_id, public_key_fetcher: TestHelper::FakeFetcher.new)

    assert decoded['exp']
    assert decoded['iat']
    assert_equal project_id, decoded['aud']
    assert_equal "https://session.firebase.google.com/#{project_id}", decoded["iss"]
    assert_equal "test", decoded['sub']
    assert_equal 'fuga', decoded['piyo']
  end
end
