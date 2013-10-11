module EndpointBase::Concerns
  module All
    extend ActiveSupport::Concern

    include EndpointBase::Concerns::TokenAuthorization
    include EndpointBase::Concerns::ParamProcessor
    include EndpointBase::Concerns::ResponseDSL
    include EndpointBase::Concerns::ExceptionHandler
  end
end
