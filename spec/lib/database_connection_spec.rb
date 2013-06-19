require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'database_connection')

describe DatabaseConnection do
  def database_exists?(conn)
    $mysql.with do |client|
      client.query('SHOW DATABASES;').map{|m| m['Database']}.include?(APP_CONFIG[:database_name])
    end
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
    it 'initializes the database with a single row with ID=1' do
      @connection.drop_database if database_exists?(@connection)
      database_exists?(@connection).should be_false
      @connection.create_database
      $mysql.with do |client|
        client.query('SELECT COUNT(*) FROM tickets;').map{|m| m['COUNT(*)']}.first.should == 1
        client.query('SELECT LAST_INSERT_ID();').map{|m| m['LAST_INSERT_ID()']}.first.should == 1
      end
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
  describe '#get_next_ticket_base_id' do
    it 'returns sequential ticket base IDs, starting at 2' do
      @connection.drop_database if database_exists?(@connection)
      database_exists?(@connection).should be_false
      @connection.create_database

      @connection.get_next_ticket_base_id.should == 2
      @connection.get_next_ticket_base_id.should == 3
      @connection.get_next_ticket_base_id.should == 4
    end
  end
  describe '#get_last_ticket_base_id' do
    it 'returns most recent ticket base ID without incrementing it' do
      @connection.create_database if !database_exists?(@connection)

      last_id = @connection.get_next_ticket_base_id
      @connection.get_last_ticket_base_id.should == last_id
      @connection.get_last_ticket_base_id.should == last_id
    end
  end
end
