require File.join(APPLICATION_ROOT, 'lib', 'ticket')

class TicketGroup

  # Create a group of tickets based on the first ticket's id,
  # the difference between adjacent tickets, and the number of
  # tickets to generate.
  def initialize(size = 2)
    initial_ticket = Ticket.new
    next_ticket = Ticket.new
    id_diff = next_ticket.id - initial_ticket.id

    @group = [initial_ticket.id, id_diff, size.to_i]
  end

  def group
    @group
  end
end
