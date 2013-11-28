require File.join(File.dirname(__FILE__), 'spec_helper')

module EndpointBase::Sinatra
  describe Base do
    let(:payload) { { :message_id => 'abc456', :payload => {} }.to_json }
    let(:headers) { {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"} }

    it 'rejects request without auth' do
      post '/', payload
      expect(last_response.status).to eq 401
    end

    it 'accepts POST with auth' do
      post '/', payload, headers
      expect(last_response).to be_ok
    end

    it 'redirects to endpoint.json for GET on root url' do
      get '/', nil, {}
      expect(last_response.status).to eq 302
      expect(last_response.location).to eq 'http://example.org/endpoint.json'
    end

    it 'returns a 200 for /auth check' do
      get '/auth', {}, headers
      expect(last_response).to be_ok
    end

    it 'parses valid json from body' do
      post '/payload', {payload: {test: 1} }.to_json, headers

      expect(::JSON.parse(last_response.body)['payload']['test']).to eq 1
    end

    it 'returns 406 if body is not valid json' do
      post '/', 'notjson', headers
      expect(last_response.status).to eq 406
    end

    it 'finds parameters' do
      body = { 'payload' => { 'parameters' => [{'name' => 'x', 'value' => 1}, {'name' => '2', 'value' => 3}] } }.to_json
      post '/config', body, headers

      response = ::JSON.parse(last_response.body)['params']
      expect(response['x']).to eq 1
      expect(response['2']).to eq 3
    end

    it 'responds with application/json' do
      post '/', payload, headers

      expect(last_response.content_type).to eq 'application/json;charset=utf-8'
    end
  end
end
