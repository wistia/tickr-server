require File.join(APPLICATION_ROOT, 'lib', 'database_interface')

class Ticket
  def self.last
    self.new(DatabaseInterface.new.get_last_ticket_base_id)
  end

  def initialize(db_id = nil)
    db_id ||= DatabaseInterface.new.get_next_ticket_base_id
    @id = ticket_id_from_db_id(db_id)
  end

  def id
    @id
  end

  private
  def ticket_id_from_db_id(db_id)
    # We subtract two from the db_id, one for each reason:
    # (1) Our first ID should be starting_offset, not starting_offset+max_nodes
    # (2) Our database is always one ID ahead of our application because MySQL
    #     requires us to seed it with 1 rather 0.
    ((db_id - 2) * APP_CONFIG[:max_nodes]) + APP_CONFIG[:node_number] + APP_CONFIG[:starting_offset]
  end
end
