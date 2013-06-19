ENV['RACK_ENV'] = "test"

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
  puts 'Ensuring database exists.'
  DatabaseInterface.new.create_database if !database_exists?
  puts 'Tables:'
  $mysql.with do |client|
    client.query("USE #{APP_CONFIG[:database_name]};")
    client.query('SHOW TABLES;').map{|m| m["Tables_in_#{APP_CONFIG[:database_name]}"]}.each{|t| puts t}
  end
end
