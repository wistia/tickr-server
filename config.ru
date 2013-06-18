require 'rubygems'
require 'bundler'

Bundler.require

require './tickr'

run Sinatra::Application
