module EndpointBase::Rails
  class Engine < ::Rails::Engine
    include EndpointBase::Concerns::RailsResponder
  end
end
