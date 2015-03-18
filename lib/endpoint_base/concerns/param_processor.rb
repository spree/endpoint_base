require 'json'

module EndpointBase::Concerns
  module ParamProcessor
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        helper Helpers

        before_action do
          prepare_payload params
          prepare_config params
        end

      elsif EndpointBase.sinatra?
        helpers Helpers

        before do
          if request.post?
            begin
              body = request.body.read
              parsed = ::JSON.parse(body).with_indifferent_access
            rescue Exception => e
              # notify of exception if Honeybadger or Airbrake or Rollbar is present
              Honeybadger.notify(e, { context: { request: body } }) if Object.const_defined?('Honeybadger')
              Airbrake.notify(e, parameters: @payload) if Object.const_defined?('Airbrake')
              Rollbar.error(e, parameters: @payload) if Object.const_defined?('Rollbar')

              halt 406
            end

            prepare_payload parsed
            prepare_config parsed
          end
        end
      end
    end

    private

    def prepare_payload(hsh)
      @payload = hsh
    end

    def prepare_config(hsh)
      if hsh.key? 'parameters'
        if hsh['parameters'].is_a? Hash
          @config = hsh['parameters']
        end
      end

      @config ||= {}
    end

    module Helpers
      def store_id
        @config['store_id']
      end
    end
  end
end
