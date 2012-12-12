$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

WORKERS = File.join(File.dirname(__FILE__), 'app', 'workers')
$LOAD_PATH.unshift(WORKERS)

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'mock_redis'
require 'sidekiq/throttler'
require 'active_support'
require 'active_support/core_ext'

# Autoload every worker for the test suite that sits in spec/app/workers
Dir[File.join(WORKERS, '*.rb')].sort.each do |file|
  name = File.basename(file, '.rb')
  autoload name.camelize.to_sym, name
end

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }