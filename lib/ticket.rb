require File.join(APPLICATION_ROOT, 'lib', 'database_connection')

class Ticket
  def self.last
    self.new(DatabaseConnection.new.get_last_ticket_base_id)
  end

  def initialize(db_id = nil)
    db_id ||= DatabaseConnection.new.get_next_ticket_base_id
    @id = ticket_id_from_db_id(db_id)
  end
  def id
    @id
  end

  private
  def ticket_id_from_db_id(db_id)
    ((db_id - 1) * APP_CONFIG[:max_nodes]) + APP_CONFIG[:node_number] + APP_CONFIG[:starting_offset]
  end
end
