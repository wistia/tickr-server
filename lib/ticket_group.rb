require File.join(APPLICATION_ROOT, 'lib', 'ticket')
require File.join(APPLICATION_ROOT, 'lib', 'database_interface')

class TicketGroup

  # Create a group of tickets based on the first ticket's id,
  # the difference between adjacent tickets, and the number of
  # tickets to generate.
  def initialize(size = 2)
    ticket = Ticket.new
    DatabaseInterface.new.increment_next_ticket_base_id(size.to_i)
    @group = [ticket.id, APP_CONFIG[:max_nodes], size.to_i]
  end

  def group
    @group
  end
end
