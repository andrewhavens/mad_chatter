lib_dir = File.expand_path('..', __FILE__)
$:.unshift( lib_dir ) unless $:.include?( lib_dir )

require 'eventmachine'
require 'redcarpet'
require 'yaml'
require 'json'
require 'digest/sha1'

module MadChatter
  
  def self.message_listeners
    @@message_listeners ||= []
  end
  
  require 'mad_chatter/config'
  require 'mad_chatter/message'
  require 'mad_chatter/server'
  require 'mad_chatter/users'
  require 'mad_chatter/version'
  require 'mad_chatter/actions/dsl'
  require 'mad_chatter/actions/base'
  require 'mad_chatter/actions/join'
  require 'mad_chatter/actions/rename'

  require 'mad_chatter/servers/em_websocket'
  
  def self.markdown
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(
        :filter_html => true, 
        :hard_wrap => true
      ), 
      :autolink => true, 
      :no_intra_emphasis => true
    )
  end

  def self.start
    config = MadChatter::Config.init
    server = MadChatter::Server.new(config)
    server.start
  end
  
end