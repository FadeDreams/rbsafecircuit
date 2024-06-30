# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbsafecircuit/version'

Gem::Specification.new do |spec|
  spec.name          = "rbsafecircuit"
  spec.version       = Rbsafecircuit::VERSION
  spec.authors       = ["fadedreams7"]
  spec.email         = ["fadedreams7@gmail.com"]
  spec.summary       = %q{A Ruby gem for implementing a circuit breaker pattern with event handling capabilities.}
  spec.description   = %q{rbsafecircuit is a Ruby gem that provides a robust implementation of the circuit breaker pattern, designed to enhance the resilience of applications by managing failures and reducing the impact of network or service-related issues. It includes features such as state management (closed, open, half-open), failure thresholds, timeout handling, and event-driven callbacks for handling success, failure, open, close, and half-open states. Built with flexibility and reliability in mind, rbsafecircuit helps developers ensure their applications remain responsive and reliable in the face of unreliable external dependencies.}
  spec.homepage      = "https://github.com/fadedreams/rbsafecircuit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'event_emitter', '~> 1.0'
  spec.required_ruby_version = '>= 2.5'
end
