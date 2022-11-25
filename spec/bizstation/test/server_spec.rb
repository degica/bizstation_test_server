# frozen_string_literal: true

RSpec.describe Bizstation::Test::Server do
  it "has a version number" do
    expect(Bizstation::Test::Server::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
