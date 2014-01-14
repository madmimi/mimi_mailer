# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mimi_mailer/version'

Gem::Specification.new do |spec|
  spec.name          = "mimi_mailer"
  spec.version       = MimiMailer::VERSION
  spec.authors       = ["Jeff Browning"]
  spec.email         = ["jeff@jkbrowning.com"]
  spec.summary       = %q{A stripped-down way to interact with the Mimi mailer API}
  spec.description   = %q{This gem is unsupported. Use at your own risk. :)}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.3'
  spec.files                 = `git ls-files`.split($/)
  spec.executables           = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files            = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths         = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "bundler", "~> 1.2"
  spec.add_development_dependency "rake"
end
