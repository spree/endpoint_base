require 'simplecov'

SimpleCov.start do
  add_filter 'spec/spec_helper'
  add_filter 'lib/endpoint_base.rb'
  coverage_dir 'coverage/sinatra'
end

require File.join(File.dirname(__FILE__), '../spec_helper')
require 'rubygems'
require 'bundler'
require 'vcr'
require 'json'
require 'sinatra'

Bundler.require(:default, :test)
require 'rack/test'

require File.join(File.dirname(__FILE__), '../..', 'lib', 'endpoint_base', 'sinatra', 'base.rb')

Sinatra::Base.environment = 'test'

def app

  Rack::Builder.new do
    map '/' do
      run TestEndpoint
    end
    map '/myapp' do
      run TestEndpoint
    end
  end.to_app
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

class NoAuthEndpoint < EndpointBase::Sinatra::Base
  post '/' do
    result 200, 'no auth!'
  end
end

class TestEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  endpoint_key 'x123'

  post '/' do
    process_result 200
  end

  # used to verify JSON parsing in param_processor
  post '/payload' do
    @payload.to_json
  end

  # used to verify parameters are correctly stored in @config
  post '/config' do
    add_value :params, @config

    process_result 200
  end

  post '/add_value' do
    add_value :priates, [  { id: 5, name: 'Blue Beard'},
                           { id: 7, name: 'Peg Eye' } ]

    process_result 200
  end

  post '/add_objects' do
    add_object :order, { id: 1, email: 'test@example.com' }
    add_object :order, { id: 2, email: 'spree@example.com' }
    add_object :product, { id: 1, sku: 'ROR-123' }

    process_result 200
  end

  post '/add_objects_nil_id' do
    begin
      add_object :product, { id: nil, sku: 'ROR-123' }
      process_result 200
    rescue => e
      result 500, e.message
    end
  end

  post '/add_parameter' do
    add_parameter 'some.param', 123

    process_result 200
  end

  post '/set_summary' do
    set_summary 'everything is ok'

    process_result 200
  end

  post '/result' do
    result 200, 'this was a success'
  end

  post '/multi_result' do
    result 500, 'this was a fail'
    result 200, 'this was a success'
  end

  post '/failure' do
    raise 'If you had used PHP, and this would not have happened'
  end
end
