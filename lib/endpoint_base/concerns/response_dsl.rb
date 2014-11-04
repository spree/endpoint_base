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

      def add_or_merge_value(name, value)
        @attrs ||= {}

        unless @attrs[name]
          @attrs[name] = value
        else
          old_value = @attrs[name]

          collection = (old_value + value).flatten
          group = collection.group_by { |h| h[:id] || h['id'] }

          @attrs[name] = group.map { |k, v| v.reduce(:merge) }
        end
      end

      def add_parameter(name, value)
        @parameters ||= {}

        @parameters[name] = value
      end

      def set_summary(summary)
        add_value(:summary, summary)
      end

      def add_object(klass, object)
        raise 'object[id] cannot be empty' if object[:id].blank? && object['id'].blank?

        @objects ||= Hash.new { |h,k| h[k] = [] }

        @objects[klass.to_s.pluralize] << object
      end
    end
  end
end
