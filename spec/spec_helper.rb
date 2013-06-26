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

def reset_database
  interface = DatabaseInterface.new
  interface.drop_database if interface.database_exists?
  interface.create_database
end

def ensure_database_exists
  interface = DatabaseInterface.new
  interface.create_database if !interface.database_exists?
end
