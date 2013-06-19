APP_CONFIG_DEFAULTS = Object.send(:remove_const, 'APP_CONFIG_DEFAULTS').merge({
  database_username: ENV['TDDIUM_DB_USER'] || 'root',
  database_password: ENV['TDDIUM_DB_PASSWORD'] || nil,
  database_name: ENV['TDDIUM_DB_NAME'] || "tickr_#{settings.environment.to_s}",
})
