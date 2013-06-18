require 'spec_helper'

describe 'The application' do
  it 'returns "Hello, World!" for root URL' do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello, world!'
  end
end
