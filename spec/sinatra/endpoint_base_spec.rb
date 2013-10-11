require File.join(File.dirname(__FILE__), 'spec_helper')

module EndpointBase::Sinatra
  describe Base do
    let(:payload) { { :message_id => 'abc456', :payload => {} }.to_json }
    let(:headers) { {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"} }

    it "should reject request without auth" do
      post '/', payload
      last_response.status.should == 401
    end

    it "should accept POST with auth" do
      post '/', payload, headers
      last_response.status.should == 200
    end

    it "should redirect to endpoint.json for GET on root url" do
      get '/', nil, {}
      last_response.status.should == 302
      last_response.location.should == 'http://example.org/endpoint.json'
    end

    it 'returns a 200 for /auth check' do
      get '/auth', {}, headers
      last_response.status.should == 200
    end

    it "should parse valid json from body" do
      post '/payload', {payload: {test: 1} }.to_json, headers
      ::JSON.parse(last_response.body)['payload']['test'].should == 1
    end

    it "should return 406 if body is not valid json" do
      post '/', 'notjson', headers
      last_response.status.should == 406
    end

    it "should find parameters" do
      body = { 'payload' => { 'parameters' => [{'name' => 'x', 'value' => 1}, {'name' => '2', 'value' => 3}] } }.to_json
      post '/config', body, headers

      response = ::JSON.parse(last_response.body)['params']
      response['x'].should == 1
      response['2'].should == 3
    end

  end
end
