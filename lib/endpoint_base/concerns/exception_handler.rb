module EndpointBase::Concerns
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        rescue_from Exception, :with => :rails_exception_handler
      elsif EndpointBase.sinatra?
        # Ensure error handlers run
        set :show_exceptions, false

        error do
          log_exception(env['sinatra.error'])
          result 500, env['sinatra.error'].message
        end
      end
    end

    private

    def rails_exception_handler(exception)
      log_exception(exception)

      result 500, exception.message
      return false
    end

    def log_exception(exception)
      if Object.const_defined?('Honeybadger')
        Honeybadger.notify(exception, { context: { request: @payload } })
      end

      if Object.const_defined?('Airbrake')
        Airbrake.notify(exception, parameters: @payload)
      end

      if Object.const_defined?('Rollbar')
        Rollbar.error(exception, parameters: @payload)
      end
    end
  end
end
