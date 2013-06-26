require 'rubygems'
require 'bundler'
Bundler.require(:default)

task :environment do
  require './boot'
end

if [:development, :test].include?(settings.environment)
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
end

import 'lib/tasks/db.rake'
