def app
  BizstationTestServer::Server
end

RSpec.describe BizstationTestServer::Server do
  # TODO: Get this from the config instead
  let(:zengin_files_dir) { BizstationTestServer.root + '/spec/zengin_files' }
  let(:example_files_dir) { BizstationTestServer.root + '/spec/example_zengin_files' }

  # TODO: Refactor to be DRY
  before { FileUtils.rm_f(Dir.glob(zengin_files_dir + '/*')) }
  after { FileUtils.rm_f(Dir.glob(zengin_files_dir + '/*')) }

  describe 'get /File/List' do
    it "Shows an XML list of the files" do
      now = Time.now
      FileUtils.copy(example_files_dir + '/receipt_zengin_file.txt',
                zengin_files_dir + '/TFS20200701_00001_010961721004A')
      FileUtils.copy(example_files_dir + '/result_zengin_file.txt',
                zengin_files_dir + '/TFS20200701_00001_010961721004B')

      get '/File/List'

      expect(last_response).to be_ok
      expect(last_response.body).to eq <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="no" ?>
        <FileListResult>
            <FileInfo>
              <FileName>TFS20200701_00001_010961721004A</FileName>
              <CreatedDate>#{now.strftime('%Y-%m-%d%M:%S')}</CreatedDate>
              <FileSize>726</FileSize>
            </FileInfo>
            <FileInfo>
              <FileName>TFS20200701_00001_010961721004B</FileName>
              <CreatedDate>#{now.strftime('%Y-%m-%d%M:%S')}</CreatedDate>
              <FileSize>726</FileSize>
            </FileInfo>
        </FileListResult>
      XML
    end
  end
end
