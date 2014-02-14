# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'netaxept/version'

Gem::Specification.new do |spec|
  spec.name          = "netaxept"
  spec.version       = Netaxept::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Peter Kordel"]
  spec.email         = ["pkordel@gmail.com"]
  spec.description   = %q{This gem provides support for the Norwegian payment provider Netaxept.}
  spec.summary       = %q{This gem provides support for the Norwegian payment provider Netaxept. See http://www.betalingsterminal.no/Netthandel-forside/ }
  spec.homepage      = "https://github.com/pkordel/netaxept"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",  "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.2.3"
  spec.add_development_dependency "dotenv",   "~> 0.9.0"
end
