require 'net/https'

module FirebaseAuthRuby
  module Util
    def self.get!(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, 443)
      http.use_ssl = true

      res = http.get(uri.path)
      raise Error unless res.is_a? Net::HTTPSuccess

      res
    end
  end
end
