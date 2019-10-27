require "test_helper"

require 'active_support/cache'

class PublicKeyFetcherTest < Minitest::Test
  URL = "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

  def test_public_key_fetcher
    FirebaseAuthRuby.cache_store = ActiveSupport::Cache::NullStore.new

    fetcher = FirebaseAuthRuby::PublicKeyFetcher.new

    res = fetcher.fetch(URL)
    assert res.is_a? Hash
  end

  def test_public_key_fetcher_with_cache
    FirebaseAuthRuby.cache_store = ActiveSupport::Cache::MemoryStore.new

    fetcher = FirebaseAuthRuby::PublicKeyFetcher.new

    first_res = fetcher.fetch(URL)
    assert first_res

    # cache response

    second_res = nil

    mock = MiniTest::Mock.new
    mock.expect :call, nil, [URL]

    FirebaseAuthRuby::Util.stub :get!, mock do
      second_res = fetcher.fetch(URL)

      assert_raises(MockExpectationError) { mock.verify }
    end

    assert second_res == first_res
  end

  def test_public_key_fetcher_with_cache_expires
    FirebaseAuthRuby.cache_store = ActiveSupport::Cache::MemoryStore.new

    fetcher = FirebaseAuthRuby::PublicKeyFetcher.new

    fetcher.fetch(URL)
    refute fetcher.instance_variable_get(:@cache_hit)

    fetcher.fetch(URL)
    assert fetcher.instance_variable_get(:@cache_hit)

    exp = FirebaseAuthRuby.cache_store.read("firebase_auth_ruby/public_keys_expire_at/#{URL}")

    Time.stub :now, exp.to_i - 1 do # not expire
      fetcher.fetch(URL)

      assert fetcher.instance_variable_get(:@cache_hit)
    end

    Time.stub :now, exp.to_i do # expire
      fetcher.fetch(URL)

      refute fetcher.instance_variable_get(:@cache_hit)
    end
  end
end
