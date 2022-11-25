require 'sinatra'

module BizstationTestServer
  class Server < Sinatra::Base
    get '/' do
      'Hello World!'
    end
  end
end

