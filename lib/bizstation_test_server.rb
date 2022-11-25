require_relative 'bizstation_test_server/server'

module BizstationTestServer
  def self.root
    File.expand_path '../..', __FILE__
  end
end
