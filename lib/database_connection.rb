class DatabaseConnection
  def create_database
    query("CREATE DATABASE `#{config[:database]}`;")
    query("USE #{config[:database]}")
    query(<<-EOS
      CREATE TABLE `tickets` (
        `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `stub` char(1) NOT NULL UNIQUE DEFAULT ''
      ) ENGINE=MyISAM AUTO_INCREMENT=1 CHARACTER SET='utf8'
    EOS
    )
    query('INSERT INTO tickets (stub) VALUES ("a");')
  end

  def drop_database
    query("DROP DATABASE `#{config[:database]}`;")
  end

  def get_next_ticket_base_id
    query('REPLACE INTO tickets (stub) VALUES ("a");')
    # Return LAST_INSERT_ID - 1, because AUTO_INCREMENT starts with 1.
    query('SELECT LAST_INSERT_ID();').map{|m| m['LAST_INSERT_ID()']}.first - 1
  end

  private
  def config
    @config ||= {
      host: APP_CONFIG[:tickr_database_host],
      username: APP_CONFIG[:tickr_database_username],
      password: APP_CONFIG[:tickr_database_password],
      database: APP_CONFIG[:tickr_database_name]
    }
  end
  def client
    @client ||= Mysql2::Client.new(
      host: config[:host],
      username: config[:username],
      password: config[:password]
    )
  end
  def query(sql)
    client.query(sql)
  end
end
