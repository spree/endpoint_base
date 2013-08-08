class EndpointBaseController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :authorize, :prepare_message, :prepare_config
  helper_method :store_id

  rescue_from Exception, :with => :exception_handler
  respond_to :json

  private
  def authorize
    unless request.headers["HTTP_X_AUGURY_TOKEN"] == ENV['ENDPOINT_KEY']
      render status: 401, text: 'unauthorized'
      return false
    end
  end

  def exception_handler(exception)
    Rails.logger.error exception.backtrace
    render status: 500, action: '500.json.jbuilder',
           locals: { error: exception.message }
    return false
  end

  def prepare_message
    @message = params.slice('message_id', 'payload')
  end

  def prepare_config
    @config = params[:payload]['parameters'] || []
    @config = @config.inject({}) do |result, param|
      result[param[:name]] = param[:value]
      result
    end
  end

  def return_message(key, payload={})
    @messages ||= []
    @messages << { :key => key, :payload => payload }
  end

  def return_parameter name, value
    @parameters ||= []
    @parameters << { :name => name, :value => value }
  end

  def store_id
    @config['store_id']
  end

end