module EndpointBase::Concerns
  module SinatraResponder
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        raise 'This Concern is only intended to be used with Sinatra.'
      elsif EndpointBase.sinatra?
        helpers Helpers

        before do
          if request.get? && request.path_info == '/'
            redirect '/endpoint.json'
          end
        end

        get '/auth' do
          status 200
        end

      end
    end

    module Helpers
      def process_result(code, response=nil)
        status code
        if response
          warn '[DEPRECATION WARNING] Passing a hash as a second argument to `process_result` is deprecated, use Response DSL instead.'
          @attrs = response
        end

        jbuilder :'response.json', views: "#{settings.root}/../app/views/application"
      end
    end

  end
end
