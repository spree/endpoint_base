require 'sinatra'
require 'integrator_utils'
require 'cross_origin'

class EndpointBase < Sinatra::Base
  register Sinatra::IntegratorUtils
  register Sinatra::CrossOrigin

  configure do
    enable :cross_origin
  end

end
