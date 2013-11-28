module EndpointBase::Concerns
  module ResponseDSL
    extend ActiveSupport::Concern

    included do
      if EndpointBase.rails?
        include Helpers
      elsif EndpointBase.sinatra?
        helpers Helpers
      end
    end

    private

    module Helpers
      def add_value(name, value)
        @attrs ||= {}
        @attrs[name] = value
      end

      def add_message(message, payload = {})
        @messages ||= []

        @messages << { message: message,
                       payload: payload }
      end

      def add_parameter(name, value)
        @parameters ||= []

        @parameters << { name: name,
                         value: value }
      end

      def add_notification(level, subject, description, options = {})
        @notifications ||= []

        @notifications << { level: level,
                            subject: subject,
                            description: description }.merge(options)
      end
    end
  end
end
