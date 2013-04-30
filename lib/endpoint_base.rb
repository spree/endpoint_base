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
      message[:payload]['parameters'] || {}
    end

    def process_result(result)
      logger.info result
      status result.first
      json result.last
    end
end
