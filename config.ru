require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'lib/bizstation_test_server'
run BizstationTestServer::Server
