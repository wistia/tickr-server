class DatabaseInterface
  def create_database
    $mysql.with do |client|
      client.query("CREATE DATABASE `#{APP_CONFIG[:database_name]}`;")
      client.query("USE #{APP_CONFIG[:database_name]};")
      client.query(<<-EOS
        CREATE TABLE `tickets` (
          `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
          `stub` char(1) NOT NULL UNIQUE DEFAULT ''
        ) ENGINE=MyISAM AUTO_INCREMENT=1 CHARACTER SET='utf8';
      EOS
      )
      client.query('INSERT INTO tickets (stub) VALUES ("a");')
    end
  end

  def create_database_if_not_exists
    create_database unless database_exists?
  end

  def drop_database
    $mysql.with do |client|
      client.query("DROP DATABASE `#{APP_CONFIG[:database_name]}`;")
    end
  end

  def get_next_ticket_base_id
    $mysql.with do |client|
      client.query("USE #{APP_CONFIG[:database_name]};")
      client.query('REPLACE INTO tickets (stub) VALUES ("a");')
      client.query('SELECT LAST_INSERT_ID();').map{|m| m['LAST_INSERT_ID()']}.first
    end
  end

  def get_last_ticket_base_id
    $mysql.with do |client|
      client.query("USE #{APP_CONFIG[:database_name]};")
      client.query('SELECT id FROM tickets;').map{|m| m['id']}.first
    end
  end

  def database_exists?
    $mysql.with do |client|
      client.query('SHOW DATABASES;').map{|m| m['Database']}.include?(APP_CONFIG[:database_name])
    end
  end
end
