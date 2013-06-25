ENV['RACK_ENV'] = "test"
ENV['TICKR_MAX_NODES'] ||= '5'
ENV['TICKR_STARTING_OFFSET'] ||= '1'
ENV['TICKR_NODE_NUMBER'] ||= '0'

require 'rubygems'
require 'bundler'
Bundler.require(:default, :test)

set :environment, :test

require File.join(File.dirname(__FILE__), '..', 'app')

require File.join(APPLICATION_ROOT, 'lib', 'database_interface')


RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

def database_exists?
  $mysql.with do |client|
    client.query('SHOW DATABASES;').map{|m| m['Database']}.include?(APP_CONFIG[:database_name])
  end
end

def reset_database
  DatabaseInterface.new.drop_database if database_exists?
  DatabaseInterface.new.create_database
end

def ensure_database_exists
  DatabaseInterface.new.create_database if !database_exists?
end
