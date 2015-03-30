module EndpointBase
  module Sinatra
    class Base < ::Sinatra::Base
      include EndpointBase::Concerns::TokenAuthorization
      include EndpointBase::Concerns::ParamProcessor
      include EndpointBase::Concerns::ResponseDSL
      include EndpointBase::Concerns::SinatraResponder
      include EndpointBase::Concerns::ExceptionHandler

      if ENV["ENDPOINT_KEY"].present?
        endpoint_key ENV["ENDPOINT_KEY"]
      end

      get '/' do
        "#{self.class.name} ok\n"
      end
    end
  end
end
