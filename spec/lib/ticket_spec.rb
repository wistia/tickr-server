require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'ticket')

require File.join(APPLICATION_ROOT, 'lib', 'database_connection')

describe Ticket do
  def database_exists?(conn)
    $mysql.with do |client|
      client.query('SHOW DATABASES;').map{|m| m['Database']}.include?(APP_CONFIG[:database_name])
    end
  end
  before do
    conn = DatabaseConnection.new
    conn.drop_database if database_exists?(conn)
    database_exists?(conn).should be_false
    conn.create_database
  end
  describe '#initialize' do
    before do
      @old_config = APP_CONFIG
      stub_const('APP_CONFIG', @old_config.merge({
        max_nodes: 10,
        starting_offset: 326,
        node_number: 3
      }))
    end
    after do
      stub_const('APP_CONFIG', @old_config)
    end
    it 'creates tickets with IDs starting at (STARTING_OFFSET + NODE_NUMBER), incremented by MAX_NODES' do
      Ticket.new.id.should == 329
      Ticket.new.id.should == 339
      Ticket.new.id.should == 349
      Ticket.new.id.should == 359
    end
  end
end
