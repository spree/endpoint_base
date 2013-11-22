# EndpointBase

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'endpoint_base'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install endpoint_base

## Usage

```ruby
require 'endpoint_base'

class SampleEndpoint < EndpointBase

  post '/sample' do
    result = { 'message_id'    => @message[:message_id],
               'notifications' => [ { 'level'       => 'info',
                                      'subject'     => 'New sample',
                                      'description' => '...' } ] }
    process_result 200, result
  end
end

```

## Testing

EndpointBase provides a `Controllers` testing support.

```ruby
# ...
require 'spree/testing_support/controllers'

# ...

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end
```

Which enables you to use `json_response` and `auth` in your Endpoint tests. It also sets `ENV['ENDPOINT_KEY'] ||= '123'`.

```ruby
require 'spec_helper'

describe SampleEndpoint do
  let(:request) { { message: 'sample:new',
                    message_id: '1234567',
                    payload: { parameters: [] } } }

  describe '/sample' do
    it 'notifies a new sample' do
      post '/sample', request.to_json, auth

      expect(last_response).to be_ok

      expect(json_response['notifications']).to have(1).item
      expect(json_response['notifications'].first).to eq ({ 'level'       => 'info',
                                                            'subject'     => 'New Sample',
                                                            'description' => '...' })
    end
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
