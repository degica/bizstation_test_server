require 'sinatra'
require 'fileutils'

module BizstationTestServer
  class Server < Sinatra::Base
    configure :production, :development do
      set :zengin_dir, BizstationTestServer.root + '/zengin_files'
    end

    configure :test do
      set :zengin_dir, BizstationTestServer.root + '/spec/zengin_files'
    end

    get '/' do
      'Hello World!'
    end

    private

    def write_files
      FileUtils.mkdir_p(settings.zengin_dir)
      File.write("#{settings.zengin_dir}/joske.txt", 'Joske gaat naar de kermis')
    end
  end
end

