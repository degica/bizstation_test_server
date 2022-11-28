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

  describe 'GET /File/List' do
    it "Shows an XML list of the files" do
      place_example_receipt_file
      place_example_result_file

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

  describe 'GET /File/Get' do
    context 'with a correct filename in the request parameters' do
      it 'returns the file contents' do
        place_example_receipt_file

        get '/File/Get', filename: 'TFS20200701_00001_010961721004A'

        expect(last_response.body.force_encoding('SHIFT_JIS')).to eq(example_receipt_zengin_file)
      end
    end

    context 'with a filename that does not exist in the request parameters' do
      it 'returns a 404 status' do
        get '/File/Get', filename: 'Half-Life 3'

        expect(last_response.status).to eq 404
        expect(last_response.body).to be_empty
      end
    end
  end

  describe 'POST /File/Put' do
    let(:zengin_file) do
       Rack::Test::UploadedFile.new(
        StringIO.new(example_submitted_zengin_file),
        'multipart/form-data',
        # The following two arguments don't really matter as the server does not do anything with
        # them. However, they need to be there or Rack won't accept a StringIO as the file.
        false,
        original_filename: 'foobar.zengin'
      )
    end

    let(:receipt_name_regex) { /TFS20200109_00001_\d+A/ }
    let(:result_name_regex) { /TFS20200109_00001_\d+B/ }

    before do
      header 'X-Filename', "TFS20200109_00001"
      post '/File/Put', {file: zengin_file}
    end

    it 'creates a receipt file' do
      filenames = Dir[zengin_files_dir + '/*']
      expect(filenames).to include(receipt_name_regex)

      receipt_filename = filenames.find { |name| name[receipt_name_regex] }
      receipt = File.read(receipt_filename).force_encoding('SHIFT_JIS')

      expect(receipt).to eq(example_receipt_zengin_file)
    end

    it 'creates a result file' do
      filenames = Dir[zengin_files_dir + '/*']
      expect(filenames).to include(result_name_regex)

      result_filename = filenames.find { |name| name[result_name_regex] }
      result = File.read(result_filename).force_encoding('SHIFT_JIS')

      expect(result).to eq(example_result_zengin_file)
    end

    it 'returns an XML response with the filename' do
      expect(last_response).to be_ok
      expect(last_response.body).to eq <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="no"?>
        <FilePutResult>
          <PathName>/SEND</PathName>
          <FileName>TFS20200109_00001</FileName>
        </FilePutResult>
      XML
    end
  end
end
