require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite'

server = WEBrick::HTTPServer.new :Port => 8090

trap('INT') { server.shutdown }

server.mount_proc '/' do |req, res|
  res.content_type = "text/text"
  res.body = req.path
end

server.start