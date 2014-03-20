require File.join(File.dirname(__FILE__), 'spec_helper')

module EndpointBase::Sinatra
  describe Base do
    let(:payload) { { :request_id => 'abc456', :order => {id: 'R123'} }.to_json }
    let(:headers) { {'HTTP_X_HUB_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"} }

    it 'rejects request without auth' do
      post '/', payload
      expect(last_response.status).to eq 401
    end

    it 'accepts POST with auth' do
      post '/', payload, headers
      expect(last_response).to be_ok

      response = ::JSON.parse(last_response.body)

      expect(response['orders']).to be_nil
      expect(response['request_id']).to eq 'abc456'
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
      body = { 'parameters' => {'x' => 1, '2' => 3} }.to_json
      post '/config', body, headers

      response = ::JSON.parse(last_response.body)['params']
      expect(response['x']).to eq 1
      expect(response['2']).to eq 3
    end

    it 'responds with application/json' do
      post '/', payload, headers

      expect(last_response.content_type).to eq 'application/json;charset=utf-8'
    end

    describe '#add_objects' do
      it 'adds objects' do
        post '/add_objects', payload, headers

        response = ::JSON.parse(last_response.body)

        expect(response['orders']).to eq([{ 'id' => 1, 'email' => 'test@example.com' },
                                                     { 'id' => 2, 'email' => 'spree@example.com' }])
        expect(response['products']).to eq([{ 'id' => 1, 'sku' => 'ROR-123' }])
      end
    end

    it 'returns parameters set' do
      post '/add_parameter', payload, headers

      response = ::JSON.parse(last_response.body)
      expect(response['parameters']['some.param']).to eq 123
    end

    it 'sets the summary' do
      post '/set_summary', payload, headers

      response = ::JSON.parse(last_response.body)
      expect(response['summary']).to eq 'everything is ok'
    end

    it 'can set response code and set summary with a single call' do
      post '/result', payload, headers

      expect(last_response.status).to eq 200
      response = ::JSON.parse(last_response.body)
      expect(response['summary']).to eq 'this was a success'
    end
  end
end
