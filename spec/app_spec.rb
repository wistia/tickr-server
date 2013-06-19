require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'Application' do
  describe 'GET /status' do
    it 'returns 200 code with last id' do
      get '/status'
      last_response.should be_ok
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
    it 'returns JSON array of tickets of length 20' do
      get '/tickets/create/20'
      last_response.should be_ok
      data = JSON.parse(last_response.body)
      data.is_a?(Array).should be_true
      data.length.should == 20
      data.each{|d| d.is_a?(Fixnum).should be_true}
    end
  end
end
