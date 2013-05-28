require 'spec_helper'

module Sinatra
  describe CrossOrigin do
    let(:payload) { {:payload => {} }.to_json }
    let(:headers) { {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json", 'HTTP_ORIGIN' => 'http://spreecommerce.com'} }

    it "should include CORS headers when ORIGIN is specified" do
      post '/', payload, headers
      last_response.headers['Access-Control-Allow-Origin'].should == 'http://spreecommerce.com'
    end

    it "should not include CORS headers when ORIGIN is not specified" do
      headers.delete('HTTP_ORIGIN')
      post '/', payload, headers
      last_response.headers['Access-Control-Allow-Origin'].should be_nil
    end

  end
end
