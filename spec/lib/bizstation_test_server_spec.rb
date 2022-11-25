RSpec.describe BizstationTestServer::Server do
  include Rack::Test::Methods

  def app
    BizstationTestServer::Server
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World!')
  end
end
