require 'database_connection'

class Ticket
  def initialize
    db_id = DatabaseConnection.new.get_next_ticket_base_id
    @id = ((db_id - 1) * APP_CONFIG[:max_nodes]) + APP_CONFIG[:node_number] + APP_CONFIG[:starting_offset]
  end
  def id
    @id
  end
end
