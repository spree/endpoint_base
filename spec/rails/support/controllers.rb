module Controllers
  def Controllers.included(mod)
    mod.before do
      request.env["HTTP_ACCEPT"] = "application/json"
      request.env["CONTENT_TYPE"] = "application/json"
      request.env["HTTP_X_HUB_TOKEN"] = "x123"
    end
  end

  def json_response
    @json_response ||= ActiveSupport::JSON.decode(response.body)
  end
end

RSpec.configure do |config|
  config.include Controllers, :type => :controller
end