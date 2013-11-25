require 'json'

module EndpointBase::Concerns
  module ParamProcessor
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        helper Helpers

        before_action do
          prepare_message params
          prepare_config params
        end

      elsif EndpointBase.sinatra?
        helpers Helpers

        before do
          if request.post?
            begin
              parsed = ::JSON.parse(request.body.read).with_indifferent_access
            rescue Exception => e
              halt 406
            end

            prepare_message parsed
            prepare_config parsed
          end
        end
      end
    end

    private

    def prepare_message(hsh)
      @message = hsh.slice('message_id', 'payload')
    end

    def prepare_config(hsh)
      @config = hsh[:payload]['parameters'] || []
      @config = @config.inject({}) do |result, param|
        result[param[:name]] = param[:value]
        result
      end
    end

    module Helpers
      def store_id
        @config['store_id']
      end
    end
  end
end
