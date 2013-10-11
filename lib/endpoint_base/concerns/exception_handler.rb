module EndpointBase::Concerns
  module ExceptionHandler
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        rescue_from Exception, :with => :exception_handler
      elsif EndpointBase.sinatra?
        error do
          puts env['sinatra.error'].message
          puts env['sinatra.error'].backtrace
        end
      end
    end

    private

    def exception_handler(exception)
      Rails.logger.error exception.backtrace
      render status: 500, action: '500.json.jbuilder',
             locals: { error: exception.message }
      return false
    end

  end
end
