require 'rubygems'
require 'bundler'
Bundler.require(:default)

task :environment do
  require './boot'
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

import 'lib/tasks/db.rake'
