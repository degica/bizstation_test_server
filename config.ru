require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'lib/bizstation-test-server'
run BizstationTestServer::Server
