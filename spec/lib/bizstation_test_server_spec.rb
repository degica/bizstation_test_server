def app
  BizstationTestServer::Server
end

RSpec.describe BizstationTestServer::Server do
  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World!')
  end
end
