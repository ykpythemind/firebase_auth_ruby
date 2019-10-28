lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "firebase_auth_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "firebase_auth_ruby"
  spec.version       = FirebaseAuthRuby::VERSION
  spec.authors       = ["Yukito Ito"]
  spec.email         = ["yukibukiyou@gmail.com"]

  spec.summary       = %q{Firebase Auth with Ruby}
  spec.description   = %q{Verify ID Token}
  spec.homepage      = "https://github.com/ykpythemind/firebase_auth_ruby"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ykpythemind/firebase_auth_ruby"
  spec.metadata["changelog_uri"] = "https://github.com/ykpythemind/firebase_auth_ruby/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "jwt", ">= 2.2"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
