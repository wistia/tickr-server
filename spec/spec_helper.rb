ENV['RACK_ENV'] = "test"

require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

set :environment, :test

require File.join(File.dirname(__FILE__), '..', 'app')

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

def database_exists?(conn)
  $mysql.with do |client|
    client.query('SHOW DATABASES;').map{|m| m['Database']}.include?(APP_CONFIG[:database_name])
  end
end