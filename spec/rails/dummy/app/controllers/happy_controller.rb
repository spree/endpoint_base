class HappyController < ApplicationController
  include EndpointBase::Concerns::All

  def index
    add_message 'spree:order:poll'
    add_parameter 'spree.order_poll.last_updated_at', 'today'
    add_parameter 'spree.order_poll.first_updated_at', 'yesterday'
    add_notification 'info', 'hello world', 'today is a good day to ...'

    render :response
  end

end
