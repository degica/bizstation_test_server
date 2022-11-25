require 'sinatra'

module BizstationTestServer
  class Server < Sinatra::Base
    get '/' do
      'Hello world!'
    end
  end
end
