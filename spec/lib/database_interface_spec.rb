require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'database_interface')

describe DatabaseInterface do
  before do
    @connection = DatabaseInterface.new
  end
  describe '#create_database_if_not_exists' do
    it 'creates the database when it does not exist' do
      @connection.drop_database if @connection.database_exists?
      @connection.should_receive(:create_database)
      @connection.create_database_if_not_exists
    end
    it 'does not create the database when it exists' do
      @connection.create_database unless @connection.database_exists?
      @connection.should_not_receive(:create_database)
      @connection.create_database_if_not_exists
    end
  end
  describe '#create_database' do
    it 'creates the MySQL database' do
      @connection.drop_database if @connection.database_exists?
      @connection.database_exists?.should be_false
      @connection.create_database
      @connection.database_exists?.should be_true
    end
    it 'initializes the database with a single row with ID=1' do
      @connection.drop_database if @connection.database_exists?()
      @connection.database_exists?.should be_false
      @connection.create_database
      $mysql.with do |client|
        client.query('SELECT COUNT(*) FROM tickets;').map{|m| m['COUNT(*)']}.first.should == 1
        client.query('SELECT id FROM tickets WHERE stub = "a";').map{|m| m['id']}.first.should == 1
      end
    end
  end
  describe '#drop_database' do
    it 'drops the MySQL database' do
      @connection.create_database if !@connection.database_exists?
      @connection.database_exists?.should be_true
      @connection.drop_database
      @connection.database_exists?.should be_false
    end
  end
  describe '#get_next_ticket_base_id' do
    it 'returns sequential ticket base IDs, starting at 2' do
      reset_database

      @connection.get_next_ticket_base_id.should == 2
      @connection.get_next_ticket_base_id.should == 3
      @connection.get_next_ticket_base_id.should == 4
    end
  end
  describe '#get_last_ticket_base_id' do
    it 'returns most recent ticket base ID without incrementing it' do
      ensure_database_exists

      last_id = @connection.get_next_ticket_base_id
      @connection.get_last_ticket_base_id.should == last_id
      @connection.get_last_ticket_base_id.should == last_id
    end
  end
  describe '#increment_next_ticket_base_id_by' do
    it 'increments the next ticket base id by the parameter specified' do
      reset_database

      @connection.get_next_ticket_base_id.should == 2
      @connection.increment_next_ticket_base_id_by(10)
      @connection.get_next_ticket_base_id.should == 13
      @connection.get_next_ticket_base_id.should == 14

      @connection.increment_next_ticket_base_id_by(20)
      @connection.get_next_ticket_base_id.should == 35
      @connection.get_next_ticket_base_id.should == 36
    end
  end
end
