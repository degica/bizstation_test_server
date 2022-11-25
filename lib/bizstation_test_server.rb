require 'sinatra'

module BizstationTestServer
  def self.root
    File.expand_path '../..', __FILE__
  end

  class Server < Sinatra::Base
    get '/' do
      'Hello World!'
    end
  end
end
