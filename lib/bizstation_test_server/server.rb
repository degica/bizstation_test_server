require 'sinatra'
require 'fileutils'
require 'erb'

module BizstationTestServer
  class Server < Sinatra::Base
    configure do
      set :list_template, ERB.new(File.read(
        BizstationTestServer.root + '/lib/bizstation_test_server/erb/file_list.xml.erb'
      ))

      set :zengin_dir, BizstationTestServer.root + '/zengin_files'
    end

    configure :test do
      set :zengin_dir, BizstationTestServer.root + '/spec/zengin_files'
    end

    get '/File/List' do
      files = Dir[settings.zengin_dir + '/*'].map { |name| File.open(name) }
      render(:list_template, files: files)
    end

    private

    def render(template_name, opts)
      template = settings.send(template_name)
      template.result_with_hash(opts).gsub(/^\s+\n/, '')
    end

    def write_files
      FileUtils.mkdir_p(settings.zengin_dir)
      File.write("#{settings.zengin_dir}/joske.txt", 'Joske gaat naar de kermis')
    end
  end
end

