require 'sinatra'
require 'fileutils'
require 'erb'

module BizstationTestServer
  class Server < Sinatra::Base
    configure do
      set :list_template, ERB.new(File.read(
        BizstationTestServer.root + '/lib/bizstation_test_server/erb/file_list.xml.erb'
      ))

      set :put_template, ERB.new(File.read(
        BizstationTestServer.root + '/lib/bizstation_test_server/erb/file_put.xml.erb'
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

    post '/File/Put' do
      filename = request.env['HTTP_X_FILENAME']
      contents = params['file']['tempfile'].open.read

      generator = ZenginFileGenerator.new(filename, contents, settings.zengin_dir)

      generator.create_receipt
      generator.create_result

      render(:put_template, filename: filename)
    end

    private

    def render(template_name, opts)
      template = settings.send(template_name)
      template.result_with_hash(opts).gsub(/^\s+\n/, '')
    end
  end
end

