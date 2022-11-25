# frozen_string_literal: true

require 'rspec'
require 'rack/test'
require_relative '../lib/bizstation_test_server'

Dir['lib/*_spec.rb'].each { |f| require_relative f }

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
