require 'spec_helper'

describe "Sinatra App" do
  let(:payload) { {}.to_json }
  let(:auth) { {'HTTP_X_AUGURY_TOKEN' => 'x123', "CONTENT_TYPE" => "application/json"} }

  it "should reject POST without auth" do
    post '/', payload
    last_response.status.should == 401
  end

  it "should accept POST with auth" do
    post '/', payload, auth
    last_response.status.should == 200
  end

  it "should parse valid json from body" do
    post '/', {test: 1}.to_json, auth
    JSON.parse(last_response.body)['test'].should == 1
  end

  it "should return 406 if body is not valid json" do
    post '/', 'notjson', auth
    last_response.status.should == 406
  end

  it "should find parameters" do
    body = { 'payload' => { 'parameters' => {'x' => 1, 2 => 3} } }.to_json
    post '/config', body, auth

    response = JSON.parse(last_response.body)
    response['x'].should == 1
    response['2'].should == 3
  end

end
