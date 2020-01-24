require "bundler/setup"
require "shoryuken/sns"

class TestWorker
  include Shoryuken::Sns::Worker

  shoryuken_options queue: 'default', topic: 'default'

  def perform(sns_msg, arg); end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Aws.config[:stub_responses] = true
    Shoryuken.worker_executor = Shoryuken::Worker::SnsExecutor
  end
end
