# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.expand_path(File.join(File.dirname(__FILE__), %w[lib endpoint_base version]))

Gem::Specification.new do |gem|
  gem.name          = 'endpoint_base'
  gem.version       = EndpointBase::VERSION
  gem.authors       = ['Andrew Hooker']
  gem.email         = ['andrew@spreecommerce.com']
  gem.description   = %q{Shared functionality for SpreeCommerce hub endpoints}
  gem.summary       = %q{SpreeCommerce hub endpoints base library}
  gem.homepage      = 'http://www.spreecommerce.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'json'
  gem.add_dependency 'jbuilder'
  gem.add_dependency 'activesupport'

  #sinatra
  gem.add_development_dependency 'sinatra', '1.4.3'
  gem.add_development_dependency 'sinatra-contrib'
  gem.add_development_dependency 'tilt-jbuilder'
  gem.add_development_dependency 'rack-test'

  #rails
  gem.add_development_dependency 'rails', "~> 4.0.0"
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'sqlite3'

  #dev
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'vcr'
  gem.add_development_dependency 'simplecov'
end

