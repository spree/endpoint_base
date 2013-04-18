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

    #begin
      @message = JSON.parse(request.body.read).symbolize_keys
    #escue
    #  halt 406
    #end
  end

  private 

    def process_result(result)
      logger.info result
      status result.first
      json result.last
    end

    def config(message)
      stores = YAML.load_file('config/stores.yml')
      if env_conf = stores[Sinatra::Base.environment.to_s]
        if env_conf.key? message[:store_id]
          env_conf[message[:store_id]].symbolize_keys
        else
          logger.error "No entry for store_id: '#{message[:store_id]} in environment: '#{Sinatra::Base.environment.to_s}' in config/stores.yml"
          {}
        end
      else
        logger.error "No entry for '#{Sinatra::Base.environment.to_s}' in config/stores.yml"
        {}
      end
  end
end
