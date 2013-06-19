APP_CONFIG_DEFAULTS = {
  database_host: 'localhost',
  database_username: 'root',
  database_password: nil,
  database_name: "tickr_#{settings.environment.to_s}",
  max_nodes: 100,
  starting_offset: 1,
  node_number: 0
}
