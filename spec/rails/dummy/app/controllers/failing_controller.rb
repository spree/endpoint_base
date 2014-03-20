class FailingController < ApplicationController
  include EndpointBase::Concerns::All

  def index
    raise 'I see dead people'
  end

  def failure
    result 500, 'this was a failure'
  end
end
