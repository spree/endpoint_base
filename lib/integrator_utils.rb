require 'sinatra/base'
require 'sinatra/json'
require 'json'
require 'active_support/core_ext/hash'

module Sinatra
  module IntegratorUtils

    module Helpers
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

    def self.registered(app)

      app.helpers Sinatra::JSON
      app.helpers IntegratorUtils::Helpers

      app.before do
        unless request.env["HTTP_X_AUGURY_TOKEN"] == ENV['ENDPOINT_KEY']
          halt 401
        end

        if request.post?
          begin
            @message = ::JSON.parse(request.body.read).symbolize_keys
            @config = config(@message)
          rescue Exception => e
            halt 406
          end
        end
      end

      app.get '/' do
        response = begin
          File.read(File.join('public', 'endpoint.json'))
        rescue 
          {'error' => 'public/endpoint.json is missing'}
        end

        process_result 200, response
      end

    end

  end

  register IntegratorUtils
end
