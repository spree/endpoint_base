module EndpointBase::Concerns
  module SinatraResponder
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        raise 'This Concern is only intended to be used with Sinatra.'
      elsif EndpointBase.sinatra?
        helpers Helpers

        get '/auth' do
          status 200
        end
      end
    end

    module Helpers
      def result(code, summary = nil)
        set_summary summary if summary
        process_result code
      end

      def process_result(code, response = nil)
        status code
        content_type 'application/json', :charset => 'utf-8'

        if response
          warn '[DEPRECATION WARNING] Passing a hash as a second argument to `process_result` is deprecated, use Response DSL instead.'
          @attrs = response
        end

        halt jbuilder(:'response.json', views: "#{EndpointBase.path_to_views}/application")
      end
    end
  end
end

