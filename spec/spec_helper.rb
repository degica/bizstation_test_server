# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

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

def example_submitted_zengin_file
  get_example_zengin_file("submitted_zengin_file.txt")
end

def example_receipt_zengin_file
  get_example_zengin_file("receipt_zengin_file.txt")
end

def example_result_zengin_file
  get_example_zengin_file("result_zengin_file.txt")
end

def get_example_zengin_file(filename)
  contents = File.open(File.dirname(__FILE__) + '/example_zengin_files/' + filename).read
  contents.force_encoding('SHIFT_JIS')
end

def place_example_receipt_file
  FileUtils.copy(example_files_dir + '/receipt_zengin_file.txt',
                 zengin_files_dir + '/TFS20200701_00001_010961721004A')
end

def place_example_result_file
  FileUtils.copy(example_files_dir + '/result_zengin_file.txt',
                 zengin_files_dir + '/TFS20200701_00001_010961721004B')
end
