require 'sinatra/base'

module Sinatra
  module CrossOrigin
    module Helpers

      # Apply cross origin headers either
      # from global config or custom config passed
      # as a hash
      def cross_origin(hash=nil)
        return unless request.env['HTTP_ORIGIN']
        settings.set hash if hash

        origin = settings.allow_origin == :any ? request.env['HTTP_ORIGIN'] : settings.allow_origin
        methods = settings.allow_methods.map{ |m| m.to_s.upcase! }.join(', ')

        headers_list = {
          'Access-Control-Allow-Origin' => origin,
          'Access-Control-Allow-Methods' => methods,
          'Access-Control-Allow-Headers' => settings.allow_headers.map(&:to_s).join(', '),
          'Access-Control-Allow-Credentials' => settings.allow_credentials.to_s,
          'Access-Control-Max-Age' => settings.max_age.to_s
        }

        headers headers_list
      end
    end

    def self.registered(app)

      app.helpers CrossOrigin::Helpers

      app.set :cross_origin, false
      app.set :allow_origin, :any
      app.set :allow_methods, [:post, :get, :options]
      app.set :allow_credentials, true
      app.set :allow_headers, ["*", "Content-Type", "Accept", "AUTHORIZATION", "Cache-Control"]
      app.set :max_age, 1728000

      app.before do
        cross_origin if settings.cross_origin
      end

    end
  end

  register CrossOrigin

end
