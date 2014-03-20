class NoAuthController < ApplicationController
  include EndpointBase::Concerns::All

  def index
    result 200, 'success without auth'
  end
end
