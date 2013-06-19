class DatabaseConnection
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

  def drop_database
    $mysql.with do |client|
      client.query("DROP DATABASE `#{APP_CONFIG[:database_name]}`;")
    end
  end

  def get_next_ticket_base_id
    $mysql.with do |client|
      client.query("USE #{APP_CONFIG[:database_name]};")
      client.query('REPLACE INTO tickets (stub) VALUES ("a");')
      # Return LAST_INSERT_ID - 1, because AUTO_INCREMENT starts with 1.
      client.query('SELECT LAST_INSERT_ID();').map{|m| m['LAST_INSERT_ID()']}.first - 1
    end
  end
end
