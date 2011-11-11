$:.unshift(File.dirname(__FILE__)) # add this directory to load path
$:.unshift(Dir.pwd) # add current working directory for loading extensions

require 'bundler'
Bundler.setup
require 'em-websocket'
require 'json'

require 'mad_chatter/server'
require 'mad_chatter/actions'

EventMachine.run do

  MadChatter::Actions.init
  
  port = ENV['PORT'] || 8100
  
  puts "Starting WebSocket server on port #{port}."
  
  server = MadChatter::Server.new(:port => port)
  server.start
  
end