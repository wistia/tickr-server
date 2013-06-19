require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'ticket')

require File.join(APPLICATION_ROOT, 'lib', 'database_interface')

describe Ticket do
  describe 'instance methods' do
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
        reset_database

        Ticket.new.id.should == 329
        Ticket.new.id.should == 339
        Ticket.new.id.should == 349
        Ticket.new.id.should == 359
      end
    end
  end
  describe 'class methods' do
    describe '#last' do
      it 'returns the ID of the last generated ticket' do
        ensure_database_exists

        last_id = Ticket.new.id
        Ticket.last.id.should == last_id
      end
    end
  end

end
