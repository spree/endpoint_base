ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require File.join(File.dirname(__FILE__), '..','..','lib','rails', 'endpoint_base_controller.rb')

Dir["./spec/rails/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.render_views
end

ENV['ENDPOINT_KEY'] = 'x123'