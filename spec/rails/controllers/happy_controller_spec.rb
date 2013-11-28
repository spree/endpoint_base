require File.join(File.dirname(__FILE__), '../spec_helper')

describe HappyController, type: 'controller' do

  let(:config) { [{ 'name' => 'spree.api_key', 'value' => '123' },
                  { 'name' => 'spree.api_url', 'value' => 'http://localhost:3000/api/' },
                  { 'name' => 'spree.api_version', 'value' => '2.0' }] }

  let(:message) {{ 'store_id' => '123229227575e4645c000001',
                   'message_id' => 'abc',
                   'payload' => { 'parameters' => config } }}


  it 'render populated response' do
    post :index, message

    response.code.should eq '200'

    json_response['messages'].size.should == 1
    msg = json_response['messages'].first
    msg['message'].should == 'spree:order:poll'
    msg['payload'].should == {}

    json_response['parameters'].size.should == 2
    param =  json_response['parameters'].first
    param['name'].should == 'spree.order_poll.last_updated_at'
    param['value'].should  == 'today'

    json_response['notifications'].size.should == 1
    note = json_response['notifications'].first
    note['level'].should == 'info'
    note['subject'].should  == 'hello world'
    note['description'].should  == 'today is a good day to ...'
  end
end
