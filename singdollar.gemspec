# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'singdollar/version'

Gem::Specification.new do |spec|
  spec.name          = "singdollar"
  spec.version       = SingDollar::VERSION
  spec.authors       = ["Chong-Yee Khoo"]
  spec.email         = ["mail@cykhoo.com"]
  spec.description   = %q{Foreign exchange rates against the Singapore Dollar (SGD)}
  spec.summary       = %q{Foreign exchange rates against the Singapore Dollar (SGD)}
  spec.homepage      = "http://www.cykhoo.com"
  spec.license       = "Copyright 2013-2014, Chong-Yee Khoo. All rights reserved."

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'factory_girl'

  spec.add_runtime_dependency 'mechanize'
  spec.add_runtime_dependency 'nokogiri'
end
