module BizstationTestServer
  def self.root
    File.expand_path '../..', __FILE__
  end
end

require_relative 'bizstation_test_server/zengin_file_generator'
require_relative 'bizstation_test_server/server'
