RSpec.describe BizstationTestServer::ZenginFileGenerator do
  describe "#generate_receipt" do
    it "returns an both the receipt filename and contents as a 2 element array" do
      service = described_class.new("TFS20200110_00001", example_submitted_zengin_file)

      filename, contents = service.generate_receipt

      expect(filename).to match(/TFS20200110_00001_\d+A/)
      expect(contents).to eq service.generate_receipt_contents
    end
  end

  describe "#generate_result" do
    it "returns an both the result filename and contents as a 2 element array" do
      service = described_class.new("TFS20200110_00001", example_submitted_zengin_file)

      filename, contents = service.generate_result

      expect(filename).to match(/TFS20200110_00001_\d+B/)
      expect(contents).to eq service.generate_result_contents
    end
  end

  describe "#generate_filename" do
    subject do
      described_class.new("TFS20200110_00001", "foobar").generate_filename(response_type)
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
      service = described_class.new('foobar', example_submitted_zengin_file)
      expect(service.generate_receipt_contents).to eq example_receipt_zengin_file
    end
  end

  describe "#generate_result_contents" do
    it "fills in the 000 codes on each line indicating a successful result" do
      service = described_class.new('foobar', example_submitted_zengin_file)
      expect(service.generate_result_contents).to eq example_result_zengin_file
    end
  end
end
