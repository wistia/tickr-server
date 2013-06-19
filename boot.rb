APPLICATION_ROOT = File.dirname(__FILE__)
require File.join(File.dirname(__FILE__), 'environments', 'base')

env_filename = File.join(File.dirname(__FILE__), 'environments', settings.environment.to_s)
require env_filename if File.exists?(env_filename)

# Load configuration from environment
ENVIRONMENT_KEYS = %w(
DATABASE_HOST DATABASE_USERNAME DATABASE_PASSWORD DATABASE_NAME
MAX_NODES STARTING_OFFSET NODE_NUMBER
)

APP_CONFIG = ENVIRONMENT_KEYS.inject({}) do |result, k|
  k_sym = k.downcase.to_sym
  result.merge(k_sym => ENV["TICKR_#{k}"].blank? ? APP_CONFIG_DEFAULTS[k_sym]: ENV["TICKR_#{k}"])
end
