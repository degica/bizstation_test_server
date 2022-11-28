RSpec.describe BizstationTestServer::ZenginFileGenerator do
  subject do
    described_class.new("TFS20200109_00001", example_submitted_zengin_file, zengin_files_dir)
  end

  let(:receipt_name_regex) { /TFS20200109_00001_\d+A/ }
  let(:result_name_regex) { /TFS20200109_00001_\d+B/ }

  before { FileUtils.rm_f(Dir.glob(zengin_files_dir + '/*')) }
  after { FileUtils.rm_f(Dir.glob(zengin_files_dir + '/*')) }

  describe "#create_receipt" do
    it "creates the receipt file" do
      subject.create_receipt

      filenames = Dir[zengin_files_dir + '/*']
      expect(filenames).to include(receipt_name_regex)

      receipt_filename = filenames.find { |name| name[receipt_name_regex] }
      receipt = File.read(receipt_filename).force_encoding('SHIFT_JIS')

      expect(receipt).to eq(example_receipt_zengin_file)
    end
  end

  describe "#create_result" do
    it "creates the result file" do
      subject.create_result

      filenames = Dir[zengin_files_dir + '/*']
      expect(filenames).to include(result_name_regex)

      result_filename = filenames.find { |name| name[result_name_regex] }
      result = File.read(result_filename).force_encoding('SHIFT_JIS')

      expect(result).to eq(example_result_zengin_file)
    end
  end

  describe "#generate_filename" do
    subject do
      described_class.new("TFS20200110_00001", "foobar", zengin_files_dir)
                     .generate_filename(response_type)
    end

    context "with a receipt" do
      let(:response_type) { :receipt }

      it "generates a filename that ends in an A" do
        expect(subject).to match(/TFS20200110_00001_\d+A/)
      end
    end

    context "with a result" do
      let(:response_type) { :result }

      it "generates a filename that ends in an B" do
        expect(subject).to match(/TFS20200110_00001_\d+B/)
      end
    end

    context "with a garbage response type" do
      let(:response_type) { "d'oh!" }

      it "raises an ArugmentError" do
        msg = 'response type must be one of [:receipt, :result]. Got: "d\'oh!"'
        expect { subject }. to raise_error(ArgumentError, msg)
      end
    end
  end

  describe "#generate_receipt_contents" do
    it "fills in the 000 codes on each line indicating a successful receipt" do
      service = described_class.new('foobar', example_submitted_zengin_file, zengin_files_dir)
      expect(service.generate_receipt_contents).to eq example_receipt_zengin_file
    end
  end

  describe "#generate_result_contents" do
    it "fills in the 000 codes on each line indicating a successful result" do
      service = described_class.new('foobar', example_submitted_zengin_file, zengin_files_dir)
      expect(service.generate_result_contents).to eq example_result_zengin_file
    end
  end
end
