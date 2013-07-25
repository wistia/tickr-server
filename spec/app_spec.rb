require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Application' do
  before do
    ensure_database_exists
  end
  describe 'GET /status' do
    it 'returns 200 code with last id' do
      get '/status'
      last_response.should be_ok
      data = JSON.parse(last_response.body)
      data.is_a?(Hash).should be_true
      data.has_key?('last_ticket').should be_true
      data['last_ticket'].is_a?(Fixnum).should be_true
      data['last_ticket'].should == Ticket.last.id
    end
  end

  describe 'GET /tickets/create' do
    it 'returns JSON array of tickets of length 1' do
      get '/tickets/create'
      last_response.should be_ok
      data = JSON.parse(last_response.body)
      data.is_a?(Array).should be_true
      data[0].is_a?(Fixnum).should be_true
    end
  end

  describe 'GET /tickets/create/20' do
    it 'returns JSON array of one ticket group' do
      get '/tickets/create/20'
      last_response.should be_ok
      data = JSON.parse(last_response.body)
      data.is_a?(Hash).should be_true
      data.length.should == 3
      data['count'].should == 20
      data.each do |k,v|
        k.is_a?(String).should be_true
        v.is_a?(Fixnum).should be_true
      end
    end
  end
end
