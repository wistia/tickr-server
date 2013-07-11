require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'ticket_group')

describe TicketGroup do
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

      it 'creates an array with initial ticket id, id difference, and size of ticket group' do
        reset_database

        TicketGroup.new(10).group.should == [329, 10, 10]
        TicketGroup.new(20).group.should == [429, 10, 20]
      end
    end
  end
end
