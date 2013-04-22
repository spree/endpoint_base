require 'spec_helper'

  def auth
    {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"}
  end

describe "Sinatra App" do
  let(:payload) { {}.to_json }
  
  it "should reject POST without auth" do
    VCR.use_cassette('without_auth') do
      post '/', payload
      last_response.status.should == 401
    end
  end

  it "should accept POST with auth" do
    VCR.use_cassette('without_auth') do
      post '/', payload, auth
      last_response.status.should == 200
    end
  end

end