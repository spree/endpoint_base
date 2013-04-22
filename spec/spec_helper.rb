require 'rubygems'
require 'bundler'
require 'vcr'

Bundler.require(:default, :test)
require 'rack/test'

require File.join(File.dirname(__FILE__), '..', 'lib', 'endpoint_base.rb')
Dir["./spec/support/**/*.rb"].each {|f| require f}

Sinatra::Base.environment = 'test'

def app
 TestEndpoint 
end
#

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

ENV['ENDPOINT_KEY'] = 'x123'

class TestEndpoint < EndpointBase

  set :logging, true

  post '/' do
    return "200"
  end
end
