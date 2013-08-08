require File.join(File.dirname(__FILE__), 'spec_helper')

describe EndpointBaseController, :type => :controller do

  let(:config) { [{ 'name' => 'spree.api_key', 'value' => '123' },
                  { 'name' => 'spree.api_url', 'value' => 'http://localhost:3000/api/' },
                  { 'name' => 'spree.api_version', 'value' => '2.0' }] }

  let(:message) {{ 'store_id' => '123229227575e4645c000001',
                   'message_id' => 'abc',
                   'payload' => { 'parameters' => config } }}


  class MyController < EndpointBaseController
  end

  controller(MyController) do
    def index
      raise 'I see dead people'
    end
  end

  describe MyController do
    it "renders to the /500.json page on exceptions" do
      post :index, message
      response.code.should eq '500'
      json_response['error'].should eq 'I see dead people'
      json_response['message_id'].should eq 'abc'
    end
  end

end