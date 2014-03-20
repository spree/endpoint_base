require File.join(File.dirname(__FILE__), '../spec_helper')

describe NoAuthController, type: 'controller' do

  let(:config) { [{ 'name' => 'spree.api_key', 'value' => '123' },
                  { 'name' => 'spree.api_url', 'value' => 'http://localhost:3000/api/' },
                  { 'name' => 'spree.api_version', 'value' => '2.0' }] }

  let(:message) {{ 'store_id' => '123229227575e4645c000001',
                   'requet_id' => 'abc',
                   'parameters' => config }}


  it 'ignores auth header, if endpoint_key not set' do
    post :index, message

    response.code.should eq '200'
    json_response['summary'].should  == 'success without auth'
  end

  it 'succeeds without auth header' do
    request.env.delete 'HTTP_X_HUB_TOKEN'
    post :index, message

    response.code.should eq '200'
    json_response['summary'].should  == 'success without auth'
  end
end
