require File.join(File.dirname(__FILE__), '..', 'database_connection')

namespace :db do
  desc 'Create the database'
  task :create => :environment do
    DatabaseConnection.new.create_database
  end

  desc 'Drop the database'
  task :drop => :environment do
    DatabaseConnection.new.drop_database
  end
end
