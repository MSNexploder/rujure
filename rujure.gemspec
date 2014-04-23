# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rujure/version'

Gem::Specification.new do |spec|
  spec.name          = "rujure"
  spec.version       = Rujure::VERSION
  spec.authors       = ["Stefan Huber"]
  spec.email         = ["MSNexploder@gmail.com"]
  spec.summary       = "JRuby - Clojure interop"
  spec.description   = "Call your Clojure using JRuby"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6.1"
  spec.add_development_dependency "rake", "~> 10.3.1"
  spec.add_development_dependency "minitest", "~> 5.3.3"
end
