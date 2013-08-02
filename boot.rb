APPLICATION_ROOT = File.dirname(__FILE__)
require File.join(File.dirname(__FILE__), 'environments', 'base')

env_filename = File.join(File.dirname(__FILE__), 'environments', settings.environment.to_s)
require env_filename if File.exists?(env_filename)

class RequiredSettingNotSetError < StandardError; end

# Load configuration from environment
ENVIRONMENT_SETTINGS = {
  'DATABASE_HOST' => :to_s,
  'DATABASE_NAME' => :to_s,
  'DATABASE_PASSWORD' => :to_s,
  'DATABASE_POOL_SIZE' => :to_i,
  'DATABASE_POOL_TIMEOUT' => :to_i,
  'DATABASE_USERNAME' => :to_s,
  'MAX_NODES' => :to_i,
  'NODE_NUMBER' => :to_i,
  'STARTING_OFFSET' => :to_i,
  'HTTP_AUTH_PASSWORD' => :to_s
}

REQUIRED_ENVIRONMENT_KEYS = %w(
  MAX_NODES STARTING_OFFSET NODE_NUMBER
)

REQUIRED_ENVIRONMENT_KEYS.each do |var|
  raise RequiredSettingNotSetError.new(message: "ENV['TICKR_#{var}'] was not set.") if ENV["TICKR_#{var}"].blank?
end

APP_CONFIG = ENVIRONMENT_SETTINGS.inject({}) do |result, elem|
  k_sym = elem[0].downcase.to_sym
  result.merge(k_sym => ENV["TICKR_#{elem[0]}"].blank? ? APP_CONFIG_DEFAULTS[k_sym] : ENV["TICKR_#{elem[0]}"].send(elem[1]))
end

$mysql = ConnectionPool.new(size: APP_CONFIG[:database_pool_size], timeout: APP_CONFIG[:database_pool_timeout]) do
  Mysql2::Client.new(
    host: APP_CONFIG[:database_host],
    username: APP_CONFIG[:database_username],
    password: APP_CONFIG[:database_password],
    reconnect: true
  )
end
