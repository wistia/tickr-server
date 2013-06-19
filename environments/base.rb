APP_CONFIG_DEFAULTS = {
  tickr_database_host: 'localhost',
  tickr_database_username: 'root',
  tickr_database_password: nil,
  tickr_database_name: "tickr_#{settings.environment.to_s}",
  tickr_max_nodes: 100,
  tickr_starting_offset: 1,
  tickr_node_number: 0
}
