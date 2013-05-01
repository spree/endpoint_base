require 'sinatra'
require 'sinatra/json'
require 'json'
require 'active_support/core_ext/hash'

class EndpointBase < Sinatra::Base
  helpers Sinatra::JSON

  before do
    unless request.env["HTTP_X_AUGURY_TOKEN"] == ENV['ENDPOINT_KEY']
      halt 401
    end

    begin
      @message = JSON.parse(request.body.read).symbolize_keys
    rescue
      halt 406
    end
  end

  private

    def config(message)
      conf = message[:payload]['parameters'] || []

      conf.inject({}) do |result, param|
        param.symbolize_keys!
        result[param[:name]] = param[:value]
        result
      end
    end

    def process_result(code, response)
      status code
      json response
    end
end
