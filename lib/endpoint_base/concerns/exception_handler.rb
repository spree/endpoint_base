module EndpointBase::Concerns
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        rescue_from Exception, :with => :exception_handler
      elsif EndpointBase.sinatra?
        error do
          log_exception(env['sinatra.error'])
        end
      end
    end

    private

    def exception_handler(exception)
      log_exception(exception)

      render status: 500, action: '500.json.jbuilder',
             locals: { error: exception.message }

      return false
    end

    def log_exception(exception)
      if Object.const_defined?('Honeybadger')
        Honeybadger.notify(exception, { context: { request: @payload } })
      end
    end
  end
end
