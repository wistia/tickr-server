require File.join(File.dirname(__FILE__), '..', 'spec_helper')

require File.join(APPLICATION_ROOT, 'lib', 'ticket_group')

describe TicketGroup do
  describe 'instance methods' do
    describe '#initialize' do
      def array_to_ticket_group(array)
        {'first' => array[0], 'increment' => array[1], 'count' => array[2]}
      end

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

        TicketGroup.new(20).group.should == array_to_ticket_group([329, 10, 20])
        TicketGroup.new(20).group.should == array_to_ticket_group([529, 10, 20])
        TicketGroup.new(40).group.should == array_to_ticket_group([729, 10, 40])
        TicketGroup.new.group.should == array_to_ticket_group([1129, 10, 2])
        TicketGroup.new.group.should == array_to_ticket_group([1149, 10, 2])
      end
    end
  end
end
