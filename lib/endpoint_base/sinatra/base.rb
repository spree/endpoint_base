module EndpointBase
  module Sinatra
    class Base < ::Sinatra::Base
      include EndpointBase::Concerns::TokenAuthorization
      include EndpointBase::Concerns::ParamProcessor
      include EndpointBase::Concerns::ResponseDSL
      include EndpointBase::Concerns::SinatraResponder
      include EndpointBase::Concerns::ExceptionHandler
    end
  end
end
