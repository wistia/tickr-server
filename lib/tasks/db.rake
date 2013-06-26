require File.join(File.dirname(__FILE__), '..', 'database_interface')

namespace :db do
  desc 'Create the database'
  task :create => :environment do
    DatabaseInterface.new.create_database
  end
  desc 'Create the database if it does not exist yet'
  task :create_if_not_exists => :environment do
    DatabaseInterface.new.create_database_if_not_exists
  end

  desc 'Drop the database'
  task :drop => :environment do
    DatabaseInterface.new.drop_database
  end
end
