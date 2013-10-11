module EndpointBase::Sinatra
  module IntegratorUtils

    def self.registered(app)

      app.before do
        if request.get? && request.path_info == '/'
          redirect '/endpoint.json'
        end
      end

    end

  end

  #register IntegratorUtils
end
