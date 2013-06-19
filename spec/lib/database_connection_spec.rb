require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'database_connection')

describe DatabaseConnection do
  def database_exists?(conn)
    conn.send(:query, 'SHOW DATABASES;').map{|m| m['Database']}.include?(APP_CONFIG[:tickr_database_name])
  end
  before do
    @connection = DatabaseConnection.new
  end
  describe '#create_database' do
    it 'creates the MySQL database' do
      @connection.drop_database if database_exists?(@connection)
      database_exists?(@connection).should be_false
      @connection.create_database
      database_exists?(@connection).should be_true
    end
  end
  describe '#drop_database' do
    it 'drops the MySQL database' do
      @connection.create_database if !database_exists?(@connection)
      database_exists?(@connection).should be_true
      @connection.drop_database
      database_exists?(@connection).should be_false
    end
  end
end