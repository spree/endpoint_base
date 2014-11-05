module EndpointBase::Concerns
  module TokenAuthorization
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        before_action :authorize_rails
        extend RailsHelpers
      elsif EndpointBase.sinatra?
        before { authorize_sinatra }
        register SinatraHelpers
      end
    end

    private

    def authorize_rails
      if @endpoint_key.present? && request.headers["HTTP_X_HUB_TOKEN"] != @endpoint_key
        render status: 401, json: {text: 'unauthorized'}
        return false
      end
    end

    def authorize_sinatra
      return unless request.post?

      if @endpoint_key = settings.endpoint_key rescue nil
        halt 401 if request.env["HTTP_X_HUB_TOKEN"] != @endpoint_key
      end
    end

    module SinatraHelpers
      def endpoint_key(key)
        set :endpoint_key, key
      end
    end

    module RailsHelpers
      def endpoint_key(key)
        prepend_before_filter do |controller|
          controller.instance_variable_set(:@endpoint_key, key)
        end
      end
    end
  end
end
