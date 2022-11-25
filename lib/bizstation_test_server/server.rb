require 'sinatra'
require 'fileutils'
require 'erb'

module BizstationTestServer
  class Server < Sinatra::Base
    configure :production, :development do
      set :zengin_dir, BizstationTestServer.root + '/zengin_files'
    end

    configure :test do
      set :zengin_dir, BizstationTestServer.root + '/spec/zengin_files'
    end

    get '/File/List' do
      files = Dir[settings.zengin_dir + '/*'].map { |name| File.open(name) }

      template_path = BizstationTestServer.root + '/lib/bizstation_test_server/erb/file_list.xml.erb'
      template = ERB.new(File.read(template_path))

      template.result_with_hash(files: files).gsub(/^\s+\n/, '')
    end

    private

    def write_files
      FileUtils.mkdir_p(settings.zengin_dir)
      File.write("#{settings.zengin_dir}/joske.txt", 'Joske gaat naar de kermis')
    end
  end
end

