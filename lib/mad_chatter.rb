lib_dir = File.expand_path('..', __FILE__)
$:.unshift( lib_dir ) unless $:.include?( lib_dir )

require 'eventmachine'
require 'yaml'
require 'json'
require 'digest/sha1'

require 'mad_chatter/action'
require 'mad_chatter/config'
require 'mad_chatter/extensions'
require 'mad_chatter/message'
require 'mad_chatter/server'
require 'mad_chatter/users'
require 'mad_chatter/version'

require 'mad_chatter/actions/join'
require 'mad_chatter/actions/rename'

require 'mad_chatter/servers/em_websocket'

module MadChatter

  def self.start
    config = MadChatter::Config.init
    server = MadChatter::Server.new(config)
    server.start
  end
  
end