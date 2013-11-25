module EndpointBase
  def self.framework
    if defined?(Rails)
      :rails
    elsif defined?(Sinatra)
      :sinatra
    end
  end

  def self.rails?
    self.framework == :rails
  end

  def self.sinatra?
    self.framework == :sinatra
  end

  def self.path_to_views
    File.expand_path("../app/views", File.dirname(__FILE__))
  end
end

require 'active_support'
require 'endpoint_base/concerns'

if EndpointBase.rails?
  require 'endpoint_base/rails'
  require 'jbuilder'
elsif EndpointBase.sinatra?
  require 'endpoint_base/sinatra'
else
  puts '[Endpoint Base] Neither Rails or Sinatra are defined, you must manually require the relevant endpoint_base files.'
end

