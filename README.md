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
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder', require: 'sinatra/jbuilder'
# ...
gem 'endpoint_base'
```

#### Endpoint

```ruby
require "sinatra"
require "endpoint_base"

class SampleEndpoint < EndpointBase::Sinatra::Base
  # optional security check, value supplied is compared against HTTP_X_HUB_TOKEN header
  # which is included in all requests sent by the hub, header is unique per integration.
  #
  # to opt of out security check, do not include this line
  endpoint_key 'abc123'

  post '/sample' do
    # Return an order object.
    add_object :order, { id: 1, email: 'test@example.com' }

    # Create or update the parameter sample.new.
    add_parameter 'sample.new', '...'

    # Return a customized key and value.
    add_value 'my_customized_key', { ... }

    #return the relevant HTTP status code, and set the notification summary.
    result 200, 'The order was imported correctly'
  end

  post '/fail' do
    #return the relevant HTTP status code, and set the notification summary.
    result 500, 'The order failed to imported'
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

  # optional security check, value supplied is compared against HTTP_X_HUB_TOKEN header
  # which is included in all requests sent by the hub, header is unique per integration.
  #
  # to opt of out security check, do not include this line
  endpoint_key 'abc123'

  def sample
    # Return an order object.
    add_object :order, { id: 1, email: 'test@example.com' }

    # Create or update the parameter sample.new.
    add_parameter 'sample.new', '...'

    # Return a customized key and value.
    add_value 'my_customized_key', { ... }

    #return the relevant HTTP status code, and set the notification summary.
    result 200, 'The order was imported correctly'
  end

  def fail
    #return the relevant HTTP status code, and set the notification summary.
    result 500, 'The order failed to imported'
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
  let(:request) { { request_id: '1234567',
                    order: {},
                    parameters: []  } }

  describe '/sample' do
    it 'notifies a new sample' do
      post '/sample', request.to_json, auth

      expect(last_response).to be_ok

      expect(json_response['summary']).to eq "Order was successfully imported"
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
