module EndpointBase::Concerns
  module TokenAuthorization
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        before_action :authorize_rails
      elsif EndpointBase.sinatra?
        before { authorize_sinatra }
      end
    end

    private

    def authorize_rails
      unless request.headers["HTTP_X_HUB_TOKEN"] == ENV['ENDPOINT_KEY']
        render status: 401, json: {text: 'unauthorized'}
        return false
      end
    end

    def authorize_sinatra
      return unless request.post?
      halt 401 if request.env["HTTP_X_HUB_TOKEN"] != ENV['ENDPOINT_KEY']
    end

  end
end
