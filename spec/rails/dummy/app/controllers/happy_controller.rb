class HappyController < ApplicationController
  include EndpointBase::Concerns::All

  endpoint_key 'x123'

  def index
    add_object :product, { id: 1, name: 'Test Product' }
    add_parameter 'spree.order_poll.last_updated_at', 'today'
    add_parameter 'spree.order_poll.first_updated_at', 'yesterday'
    set_summary 'today is a good day to ...'

    process_result 200
  end

  def success
    result 200, 'this was a success'
  end
end
