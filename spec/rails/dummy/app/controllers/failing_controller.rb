class FailingController < ApplicationController
  include EndpointBase::Concerns::All

  def index
    raise 'I see dead people'
  end
end
