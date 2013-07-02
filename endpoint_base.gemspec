# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "endpoint_base"
  gem.version       = '2.0'
  gem.authors       = ["Andrew Hooker"]
  gem.email         = ["andrew@spreecommerce.com"]
  gem.description   = %q{Shared functionality for spree professional endpoints}
  gem.summary       = %q{Spree Endpoints}
  gem.homepage      = "http://www.spreecommerce.com"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'sinatra', '1.4.3'
  gem.add_dependency 'sinatra-contrib'
  gem.add_dependency 'json'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'vcr'
end

