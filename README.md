# EndpointBase

Shared functionality for SpreeCommerce Hub Endpoints.

## Installation

Add this line to your application's Gemfile:

    gem 'endpoint_base'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install endpoint_base

## Usage

### Sinatra

#### Gemfile

```ruby
gem 'sinatra'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
# ...
gem 'endpoint_base'
```

#### Endpoint

```ruby
class SampleEndpoint < EndpointBase::Sinatra::Base
  post '/sample' do
    # Return a message sample:new.
    add_message 'sample:new', { sample: { ... } }

    # Create or update the parameter sample.new.
    add_parameter 'sample.new', '...'

    # Return a notification info. The three levels available are: info, warn and error.
    add_notification 'info', 'Info subject', 'Info description'

    # Return a customized key and value.
    add_value 'my_customized_key', { ... }

    process_result 200
  end

  post '/fail' do
    # Return a notification error.
    add_notification 'error', 'Error subject', '...'

    process_result 500
  end
end

```

### Rails

#### Gemfile

```ruby
gem 'rails'
# ...
gem 'endpoint_base'
```

#### Endpoint

```ruby
class SampleController < ApplicationController
  include EndpointBase::Concerns::All
  skip_before_filter :verify_authenticity_token

  def sample
    # Return a message sample:new.
    add_message 'sample:new', { sample: { ... } }

    # Create or update the parameter sample.new.
    add_parameter 'sample.new', '...'

    # Return a notification info. The three levels available are: info, warn and error.
    add_notification 'info', 'Info subject', 'Info description'

    # Return a customized key and value.
    add_value 'my_customized_key', { ... }

    process_result 200
  end

  def fail
    # Return a notification error.
    add_notification 'error', 'Error subject', '...'

    process_result 500
  end
end

```

### Testing

##### spec_helper.rb

```ruby
# ...
require 'spree/testing_support/controllers'

# ...

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Spree::TestingSupport::Controllers
end
```

`Spree:TestingSupport::Controllers` enables you to use `json_response` and `auth` in your Endpoint tests. It also sets `ENV['ENDPOINT_KEY'] ||= '123'`.

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
                                                            'subject'     => 'Info subject',
                                                            'description' => 'Info description' })
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
